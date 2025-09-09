---
layout: example
title: "ML Training Pipeline"
description: "End-to-end machine learning pipeline for image classification with MLOps best practices"
outcome_type: "ml-pipeline"
complexity: "advanced"
stack: "Python + PyTorch + MLflow + Kubernetes"
tags: ["ml", "pytorch", "mlops", "kubernetes", "computer-vision"]
---

# ML Training Pipeline

This example demonstrates building a complete machine learning pipeline for image classification, including data processing, model training, evaluation, deployment, and monitoring with MLOps best practices.

## OSpec Document

```yaml
ospec_version: "1.0.0"
id: "image-classification-pipeline"
name: "Image Classification ML Pipeline"
description: "End-to-end ML pipeline for classifying product images with automated training, evaluation, and deployment"
outcome_type: "ml-pipeline"

# ML Pipeline Configuration
ml_pipeline:
  problem_type: "image_classification"
  model_type: "convolutional_neural_network"
  
  # Dataset configuration
  data:
    source: "s3://company-data/product-images/"
    format: "images + labels.csv"
    classes: ["electronics", "clothing", "home", "books", "toys"]
    
    splits:
      train: 0.7
      validation: 0.15
      test: 0.15
    
    preprocessing:
      - "resize: 224x224"
      - "normalize: imagenet_stats"
      - "augmentation: rotation, flip, crop"
  
  # Model architecture
  model:
    base_architecture: "ResNet50"
    pretrained: true
    num_classes: 5
    dropout_rate: 0.3
    
    # Training configuration
    training:
      batch_size: 32
      learning_rate: 0.001
      epochs: 50
      optimizer: "Adam"
      scheduler: "ReduceLROnPlateau"
      early_stopping:
        patience: 10
        monitor: "val_accuracy"

stack:
  language: "Python@3.11"
  ml_framework: "PyTorch@2.0"
  experiment_tracking: "MLflow@2.7"
  data_processing: "Pandas + PIL"
  containerization: "Docker"
  orchestration: "Kubernetes + Kubeflow"
  model_serving: "TorchServe"
  monitoring: "Prometheus + Grafana"

# Infrastructure requirements
infrastructure:
  training:
    compute: "GPU-enabled nodes (NVIDIA V100 or better)"
    storage: "1TB for datasets and artifacts"
    memory: "32GB RAM minimum"
  
  serving:
    compute: "CPU nodes (GPU optional for high throughput)"
    replicas: "2-10 (auto-scaling)"
    memory: "8GB RAM per replica"

# Acceptance criteria for ML pipeline
acceptance:
  model_performance:
    accuracy_min: 0.85
    precision_min: 0.80  # per class
    recall_min: 0.80     # per class
    f1_score_min: 0.80   # macro average
    
  # Performance benchmarks
  inference_performance:
    latency_p99_ms: 500
    throughput_rps: 100
    memory_usage_mb: 2048
  
  # Data quality checks
  data_validation:
    - name: "schema_validation"
      description: "Validate data schema and types"
    - name: "data_drift_detection"
      description: "Monitor for distribution changes"
    - name: "missing_values_check"
      description: "Ensure no missing critical values"
  
  # Model validation
  model_validation:
    - name: "bias_fairness_check"
      description: "Ensure model fairness across demographic groups"
    - name: "robustness_testing"
      description: "Test model with adversarial examples"
    - name: "explainability_tests"
      description: "Generate and validate model explanations"
  
  # MLOps capabilities
  mlops_requirements:
    - "experiment_tracking_enabled"
    - "model_versioning_implemented"
    - "automated_training_pipeline"
    - "automated_deployment_pipeline"
    - "monitoring_and_alerting_configured"
    - "rollback_capability_tested"

# Experiment tracking configuration
experiment_tracking:
  mlflow:
    tracking_uri: "{{secrets.MLFLOW_TRACKING_URI}}"
    experiment_name: "product-image-classification"
    
    # Metrics to track
    metrics:
      - "accuracy"
      - "precision"
      - "recall"
      - "f1_score"
      - "loss"
      - "val_accuracy"
      - "val_loss"
    
    # Parameters to log
    parameters:
      - "learning_rate"
      - "batch_size"
      - "architecture"
      - "optimizer"
      - "data_augmentation"
    
    # Artifacts to save
    artifacts:
      - "trained_model"
      - "training_logs"
      - "confusion_matrix"
      - "feature_importance"
      - "model_explainability_reports"

# Data pipeline configuration
data_pipeline:
  ingestion:
    source: "S3"
    schedule: "daily"
    validation:
      - "file_format_check"
      - "schema_validation"
      - "data_quality_checks"
  
  preprocessing:
    steps:
      - name: "image_validation"
        description: "Check image format, size, corruption"
      - name: "data_augmentation"
        description: "Apply training augmentations"
      - name: "normalization"
        description: "Normalize pixel values"
      - name: "dataset_split"
        description: "Split into train/val/test sets"
  
  storage:
    processed_data: "s3://company-ml/processed-data/"
    features: "s3://company-ml/features/"
    artifacts: "s3://company-ml/artifacts/"

# Training pipeline
training_pipeline:
  trigger: "scheduled"  # or "on_demand", "data_change"
  schedule: "weekly"
  
  stages:
    data_validation:
      validations:
        - "schema_compliance"
        - "data_drift_detection"
        - "missing_value_analysis"
      
    feature_engineering:
      transformations:
        - "image_preprocessing"
        - "augmentation_pipeline"
        - "feature_extraction"
    
    model_training:
      hyperparameter_tuning:
        method: "bayesian_optimization"
        trials: 50
        parameters:
          learning_rate: [0.0001, 0.01]
          batch_size: [16, 32, 64]
          dropout_rate: [0.1, 0.5]
      
      cross_validation:
        folds: 5
        strategy: "stratified"
    
    model_evaluation:
      metrics:
        - "accuracy"
        - "precision_recall_per_class"
        - "confusion_matrix" 
        - "roc_auc"
      
      tests:
        - "bias_detection"
        - "robustness_testing"
        - "explainability_analysis"
    
    model_registration:
      registry: "MLflow Model Registry"
      staging_promotion: "automatic"  # if tests pass
      production_promotion: "manual"  # requires approval

# Model deployment configuration
deployment:
  serving_framework: "TorchServe"
  
  environments:
    staging:
      replicas: 1
      resources:
        cpu: "2 cores"
        memory: "4GB"
        gpu: "optional"
      
      traffic_routing: "canary"
      canary_percentage: 10
    
    production:
      replicas: 3
      resources:
        cpu: "4 cores"
        memory: "8GB"
        gpu: "1 GPU (optional)"
      
      auto_scaling:
        min_replicas: 2
        max_replicas: 10
        target_cpu_percent: 70
        target_memory_percent: 80
  
  # A/B testing configuration
  ab_testing:
    enabled: true
    framework: "MLflow AB Testing"
    traffic_split:
      - model_version: "current_production"
        percentage: 80
      - model_version: "challenger"
        percentage: 20
    
    success_metrics:
      - "accuracy"
      - "latency"
      - "business_kpi"

# Monitoring and observability
monitoring:
  model_performance:
    metrics:
      - "prediction_accuracy"
      - "inference_latency"
      - "throughput"
      - "error_rate"
    
    data_drift:
      detector: "Evidently AI"
      schedule: "daily"
      threshold: 0.1
    
    model_drift:
      method: "KL_divergence"
      baseline: "training_distribution"
      threshold: 0.05
  
  alerting:
    channels: ["slack", "email", "pagerduty"]
    
    alerts:
      - name: "model_accuracy_drop"
        condition: "accuracy < 0.80"
        severity: "critical"
      
      - name: "high_inference_latency"
        condition: "p99_latency > 1000ms"
        severity: "warning"
      
      - name: "data_drift_detected"
        condition: "drift_score > 0.1"
        severity: "warning"

# Security and compliance
security:
  data_privacy:
    - "pii_detection_and_masking"
    - "data_encryption_at_rest"
    - "data_encryption_in_transit"
  
  model_security:
    - "adversarial_robustness_testing"
    - "model_watermarking"
    - "access_control_and_audit_logs"
  
  compliance:
    frameworks: ["GDPR", "SOX", "HIPAA"]
    requirements:
      - "data_lineage_tracking"
      - "model_explainability"
      - "audit_trail_maintenance"

guardrails:
  quality_gates:
    - "data_validation_passes"
    - "model_performance_meets_threshold"
    - "bias_fairness_tests_pass"
    - "security_scans_clear"
    - "load_testing_successful"
  
  human_approval_required:
    - "production_deployment"
    - "model_architecture_changes"
    - "data_source_modifications"
    - "compliance_configuration_changes"

# CI/CD for ML
ci_cd:
  triggers:
    - "code_push"
    - "data_change"
    - "scheduled_training"
  
  pipeline_stages:
    - name: "code_quality"
      steps:
        - "unit_tests"
        - "integration_tests"
        - "code_linting"
        - "security_scanning"
    
    - name: "data_validation"
      steps:
        - "data_schema_validation"
        - "data_quality_checks"
        - "drift_detection"
    
    - name: "model_training"
      steps:
        - "hyperparameter_tuning"
        - "model_training"
        - "model_evaluation"
        - "performance_testing"
    
    - name: "deployment"
      steps:
        - "model_packaging"
        - "staging_deployment"
        - "integration_testing"
        - "production_deployment"

metadata:
  business_context:
    problem: "Automatically categorize product images for e-commerce catalog"
    success_metrics:
      - "classification_accuracy > 85%"
      - "processing_time < 500ms per image"
      - "cost_per_classification < $0.001"
  
  technical_context:
    datasets: "100K+ labeled product images"
    computational_requirements: "GPU training, CPU serving"
    scalability_requirements: "10K+ predictions per day"
  
  team_context:
    data_scientists: 2
    ml_engineers: 2
    devops_engineers: 1
    estimated_timeline_weeks: 12
```

## Key Components

### 1. Data Pipeline

```python
# data_pipeline.py
import torch
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms
from PIL import Image
import pandas as pd
import mlflow

class ProductImageDataset(Dataset):
    def __init__(self, csv_file, img_dir, transform=None):
        self.annotations = pd.read_csv(csv_file)
        self.img_dir = img_dir
        self.transform = transform
    
    def __len__(self):
        return len(self.annotations)
    
    def __getitem__(self, idx):
        img_path = os.path.join(self.img_dir, self.annotations.iloc[idx, 0])
        image = Image.open(img_path).convert('RGB')
        label = self.annotations.iloc[idx, 1]
        
        if self.transform:
            image = self.transform(image)
        
        return image, label

def create_data_loaders(data_dir, batch_size=32):
    """Create training and validation data loaders"""
    
    # Data augmentation for training
    train_transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.RandomHorizontalFlip(p=0.5),
        transforms.RandomRotation(degrees=15),
        transforms.ColorJitter(brightness=0.2, contrast=0.2),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                           std=[0.229, 0.224, 0.225])
    ])
    
    # No augmentation for validation
    val_transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                           std=[0.229, 0.224, 0.225])
    ])
    
    train_dataset = ProductImageDataset(
        csv_file=f"{data_dir}/train_labels.csv",
        img_dir=f"{data_dir}/train_images",
        transform=train_transform
    )
    
    val_dataset = ProductImageDataset(
        csv_file=f"{data_dir}/val_labels.csv",
        img_dir=f"{data_dir}/val_images", 
        transform=val_transform
    )
    
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False)
    
    return train_loader, val_loader
```

### 2. Model Training

```python
# training.py
import torch
import torch.nn as nn
import torchvision.models as models
import mlflow
import mlflow.pytorch
from sklearn.metrics import accuracy_score, classification_report

class ImageClassifier(nn.Module):
    def __init__(self, num_classes=5, dropout_rate=0.3):
        super().__init__()
        self.backbone = models.resnet50(pretrained=True)
        
        # Freeze backbone layers initially
        for param in self.backbone.parameters():
            param.requires_grad = False
        
        # Replace final layer
        num_features = self.backbone.fc.in_features
        self.backbone.fc = nn.Sequential(
            nn.Dropout(dropout_rate),
            nn.Linear(num_features, 512),
            nn.ReLU(),
            nn.Dropout(dropout_rate),
            nn.Linear(512, num_classes)
        )
    
    def forward(self, x):
        return self.backbone(x)

def train_model(model, train_loader, val_loader, num_epochs=50):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
    scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, patience=5)
    
    # Start MLflow run
    with mlflow.start_run():
        # Log hyperparameters
        mlflow.log_params({
            "epochs": num_epochs,
            "learning_rate": 0.001,
            "batch_size": train_loader.batch_size,
            "optimizer": "Adam",
            "architecture": "ResNet50"
        })
        
        best_val_acc = 0.0
        patience_counter = 0
        
        for epoch in range(num_epochs):
            # Training phase
            model.train()
            train_loss = 0.0
            train_correct = 0
            train_total = 0
            
            for images, labels in train_loader:
                images, labels = images.to(device), labels.to(device)
                
                optimizer.zero_grad()
                outputs = model(images)
                loss = criterion(outputs, labels)
                loss.backward()
                optimizer.step()
                
                train_loss += loss.item()
                _, predicted = torch.max(outputs.data, 1)
                train_total += labels.size(0)
                train_correct += (predicted == labels).sum().item()
            
            # Validation phase
            model.eval()
            val_loss = 0.0
            val_correct = 0
            val_total = 0
            all_predictions = []
            all_labels = []
            
            with torch.no_grad():
                for images, labels in val_loader:
                    images, labels = images.to(device), labels.to(device)
                    outputs = model(images)
                    loss = criterion(outputs, labels)
                    
                    val_loss += loss.item()
                    _, predicted = torch.max(outputs.data, 1)
                    val_total += labels.size(0)
                    val_correct += (predicted == labels).sum().item()
                    
                    all_predictions.extend(predicted.cpu().numpy())
                    all_labels.extend(labels.cpu().numpy())
            
            # Calculate metrics
            train_acc = 100 * train_correct / train_total
            val_acc = 100 * val_correct / val_total
            
            # Log metrics to MLflow
            mlflow.log_metrics({
                "train_loss": train_loss / len(train_loader),
                "train_accuracy": train_acc,
                "val_loss": val_loss / len(val_loader),
                "val_accuracy": val_acc
            }, step=epoch)
            
            # Learning rate scheduling
            scheduler.step(val_loss / len(val_loader))
            
            # Early stopping
            if val_acc > best_val_acc:
                best_val_acc = val_acc
                patience_counter = 0
                # Save best model
                torch.save(model.state_dict(), "best_model.pth")
            else:
                patience_counter += 1
                if patience_counter >= 10:
                    print(f"Early stopping at epoch {epoch}")
                    break
            
            print(f"Epoch {epoch}: Train Acc: {train_acc:.2f}%, Val Acc: {val_acc:.2f}%")
        
        # Log final classification report
        report = classification_report(all_labels, all_predictions, output_dict=True)
        mlflow.log_metrics({
            "final_accuracy": report['accuracy'],
            "macro_precision": report['macro avg']['precision'],
            "macro_recall": report['macro avg']['recall'],
            "macro_f1": report['macro avg']['f1-score']
        })
        
        # Save model to MLflow
        mlflow.pytorch.log_model(model, "model")
        
    return model
```

### 3. Model Serving

```python
# serving.py
import torch
from torchvision import transforms
from PIL import Image
import mlflow.pytorch
import json

class ModelHandler:
    def __init__(self, model_uri):
        self.model = mlflow.pytorch.load_model(model_uri)
        self.model.eval()
        
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406],
                               std=[0.229, 0.224, 0.225])
        ])
        
        self.class_names = ["electronics", "clothing", "home", "books", "toys"]
    
    def preprocess(self, image_bytes):
        """Preprocess image for inference"""
        image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        return self.transform(image).unsqueeze(0)
    
    def predict(self, image_bytes):
        """Make prediction on image"""
        with torch.no_grad():
            image_tensor = self.preprocess(image_bytes)
            outputs = self.model(image_tensor)
            probabilities = torch.nn.functional.softmax(outputs[0], dim=0)
            predicted_class = torch.argmax(probabilities).item()
            confidence = probabilities[predicted_class].item()
            
            return {
                "predicted_class": self.class_names[predicted_class],
                "confidence": confidence,
                "all_probabilities": {
                    class_name: prob.item() 
                    for class_name, prob in zip(self.class_names, probabilities)
                }
            }

# FastAPI serving endpoint
from fastapi import FastAPI, File, UploadFile
import uvicorn

app = FastAPI()
model_handler = ModelHandler("models:/product-classifier/Production")

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    prediction = model_handler.predict(contents)
    return prediction

@app.get("/health")
async def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### 4. Monitoring and Drift Detection

```python
# monitoring.py
import pandas as pd
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metric_preset import DataDriftPreset
import mlflow
import numpy as np

class ModelMonitor:
    def __init__(self, reference_data_path):
        self.reference_data = pd.read_csv(reference_data_path)
        
    def detect_data_drift(self, current_data):
        """Detect data drift using Evidently"""
        
        report = Report(metrics=[DataDriftPreset()])
        report.run(
            reference_data=self.reference_data,
            current_data=current_data
        )
        
        drift_results = report.as_dict()
        
        # Log drift metrics to MLflow
        with mlflow.start_run():
            mlflow.log_metrics({
                "data_drift_detected": int(drift_results['metrics'][0]['result']['dataset_drift']),
                "drift_share": drift_results['metrics'][0]['result']['drift_share']
            })
        
        return drift_results
    
    def monitor_model_performance(self, predictions, ground_truth):
        """Monitor model performance metrics"""
        accuracy = np.mean(predictions == ground_truth)
        
        with mlflow.start_run():
            mlflow.log_metrics({
                "current_accuracy": accuracy,
                "num_predictions": len(predictions)
            })
        
        # Alert if accuracy drops below threshold
        if accuracy < 0.80:
            self.send_alert("Model accuracy dropped below 80%")
    
    def send_alert(self, message):
        """Send alert to monitoring system"""
        # Integration with alerting system
        print(f"ALERT: {message}")
```

## Deployment Architecture

### Kubernetes Deployment

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: image-classifier
spec:
  replicas: 3
  selector:
    matchLabels:
      app: image-classifier
  template:
    metadata:
      labels:
        app: image-classifier
    spec:
      containers:
      - name: model-server
        image: company/image-classifier:latest
        ports:
        - containerPort: 8000
        resources:
          requests:
            memory: "4Gi"
            cpu: "2"
          limits:
            memory: "8Gi"
            cpu: "4"
        env:
        - name: MODEL_URI
          value: "models:/product-classifier/Production"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: image-classifier-service
spec:
  selector:
    app: image-classifier
  ports:
  - port: 80
    targetPort: 8000
  type: LoadBalancer
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: image-classifier-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: image-classifier
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

## Benefits

### Technical Benefits
- **Automated workflow** from data to deployment
- **Experiment tracking** for reproducible research
- **Model versioning** and registry management
- **Monitoring and alerting** for production reliability
- **Scalable serving** with auto-scaling capabilities

### Business Benefits
- **Faster time-to-market** for ML models
- **Improved model reliability** and performance
- **Reduced operational overhead** through automation
- **Better compliance** with audit trails and governance

## Advanced Features

### A/B Testing Framework

```python
# ab_testing.py
import random
from typing import Dict, Any

class ABTestingFramework:
    def __init__(self, model_versions: Dict[str, Any], traffic_split: Dict[str, float]):
        self.model_versions = model_versions
        self.traffic_split = traffic_split
    
    def route_request(self, request_id: str):
        """Route request to appropriate model version based on traffic split"""
        rand = random.random()
        cumulative = 0
        
        for version, percentage in self.traffic_split.items():
            cumulative += percentage / 100
            if rand <= cumulative:
                return self.model_versions[version]
        
        # Fallback to first model
        return next(iter(self.model_versions.values()))
    
    def log_prediction(self, request_id: str, model_version: str, prediction: Any, 
                      latency: float, business_metric: float = None):
        """Log prediction for A/B test analysis"""
        with mlflow.start_run():
            mlflow.log_metrics({
                f"prediction_latency_{model_version}": latency,
                f"business_metric_{model_version}": business_metric or 0
            })
```

### Feature Store Integration

```python
# feature_store.py
from feast import FeatureStore
import pandas as pd

class ProductFeatureStore:
    def __init__(self):
        self.store = FeatureStore(repo_path="feature_repo/")
    
    def get_features(self, product_ids: list, timestamp=None):
        """Retrieve features for products"""
        entity_df = pd.DataFrame({"product_id": product_ids})
        
        if timestamp:
            entity_df["event_timestamp"] = timestamp
        
        features = self.store.get_historical_features(
            entity_df=entity_df,
            features=[
                "product_stats:category_score",
                "product_stats:popularity_rank",
                "product_stats:price_tier"
            ]
        ).to_df()
        
        return features
```

## Related Examples

- [API Service →](/examples/api-service/) - Model serving APIs
- [Infrastructure →](/specification/extensibility-plugins/) - ML infrastructure patterns
- [Mobile App →](/examples/mobile-app/) - Edge ML deployment

## Next Steps

1. **Advanced architectures** - Implement transformer models, ensemble methods
2. **Edge deployment** - Deploy models to mobile/edge devices
3. **Federated learning** - Implement privacy-preserving distributed training
4. **Multi-modal models** - Combine image, text, and structured data
5. **Real-time learning** - Implement online learning capabilities