---
layout: example
title: "Expense Tracker Mobile App"
description: "Cross-platform mobile app for expense tracking with receipt scanning, budgets, and analytics"
outcome_type: "mobile-app"
complexity: "advanced"
stack: "React Native + Expo"
github: "https://github.com/nibzard/ospec-examples/tree/main/expense-tracker"
---

# Expense Tracker Mobile App

A comprehensive cross-platform mobile application built with React Native and Expo that provides powerful expense tracking capabilities including receipt scanning, budget management, real-time analytics, and multi-currency support.

## OSpec Definition

```yaml
ospec_version: "1.0.0"
id: "expense-tracker-mobile"
name: "Expense Tracker Mobile App"
description: "Cross-platform expense tracking app with receipt scanning, budgets, analytics, and offline support"
outcome_type: "mobile-app"

acceptance:
  user_flows:
    - name: "expense_entry_flow"
      description: "Add new expense manually or via receipt scan"
      steps:
        - open_add_expense_screen
        - choose_entry_method # manual or scan
        - capture_receipt_or_enter_details
        - categorize_expense
        - add_notes_and_tags
        - save_expense
      completion_time_max_seconds: 60
      success_rate_threshold: 0.95

    - name: "receipt_scanning_flow"
      description: "Scan receipt and extract expense data"
      steps:
        - open_camera_scanner
        - capture_receipt_image
        - process_ocr_extraction
        - verify_extracted_data
        - save_processed_expense
      completion_time_max_seconds: 30
      accuracy_threshold: 0.85

    - name: "budget_management_flow"
      description: "Create and manage budgets"
      steps:
        - navigate_to_budgets
        - create_new_budget
        - set_category_and_amount
        - configure_time_period
        - enable_notifications
        - save_budget
      completion_time_max_seconds: 120

    - name: "analytics_viewing_flow"
      description: "View spending analytics and reports"
      steps:
        - navigate_to_analytics
        - select_time_period
        - view_spending_breakdown
        - analyze_category_trends
        - export_report_if_needed
      completion_time_max_seconds: 45

  core_features:
    expense_management:
      - manual_expense_entry: true
      - receipt_scanning: true
      - expense_editing: true
      - expense_deletion: true
      - bulk_operations: true

    categorization:
      - predefined_categories: true
      - custom_categories: true
      - category_colors: true
      - subcategories: true
      - tags_support: true

    budgets:
      - monthly_budgets: true
      - category_budgets: true
      - spending_alerts: true
      - budget_progress_tracking: true
      - rollover_budget_support: true

    analytics:
      - spending_trends: true
      - category_breakdown: true
      - monthly_comparisons: true
      - custom_date_ranges: true
      - export_capabilities: true

    synchronization:
      - cloud_sync: true
      - offline_support: true
      - conflict_resolution: true
      - multi_device_sync: true

  performance:
    app_launch_time_ms: 2000
    screen_transition_time_ms: 300
    receipt_scan_processing_time_s: 5
    data_sync_time_s: 10
    offline_functionality: true
    battery_usage_rating: "acceptable"

  platform_requirements:
    ios:
      minimum_version: "13.0"
      target_version: "17.0"
      required_permissions:
        - camera
        - photo_library
        - location # for merchant detection

    android:
      minimum_sdk: 26  # Android 8.0
      target_sdk: 34   # Android 14
      required_permissions:
        - CAMERA
        - READ_EXTERNAL_STORAGE
        - WRITE_EXTERNAL_STORAGE
        - ACCESS_FINE_LOCATION

  accessibility:
    screen_reader_support: true
    high_contrast_mode: true
    font_scaling: true
    voice_control: true
    wcag_aa_compliance: true

  security:
    biometric_authentication: true
    app_lock_timeout: 300  # seconds
    data_encryption_at_rest: true
    secure_api_communication: true
    no_screenshot_in_background: true

  tests:
    - file: "__tests__/**/*.test.{js,jsx,ts,tsx}"
      type: "unit"
      coverage_threshold: 0.8
    - file: "e2e/**/*.e2e.js"
      type: "e2e"
      framework: "Detox"
      coverage_threshold: 0.6

stack:
  framework: "React Native 0.72+"
  development_platform: "Expo SDK 49+"
  state_management: "Redux Toolkit + RTK Query"
  navigation: "React Navigation 6"
  ui_components: "React Native Elements + custom"
  database_local: "SQLite with Expo SQLite"
  cloud_backend: "Supabase"
  authentication: "Supabase Auth with biometrics"
  file_storage: "Expo FileSystem + Supabase Storage"
  image_processing: "Expo ImagePicker + ImageManipulator"
  ocr_service: "Google Cloud Vision API"
  notifications: "Expo Notifications"
  analytics: "Expo Analytics + custom events"
  maps: "Expo Location + react-native-maps"
  charts: "react-native-chart-kit"
  testing: "Jest + React Native Testing Library + Detox"
  ci_cd: "EAS Build + EAS Submit"

guardrails:
  tests_required: true
  min_test_coverage: 0.8
  accessibility_testing: true
  performance_testing: true
  security_scan: true
  app_store_compliance: true
  privacy_policy_required: true
  data_retention_policy: true
  human_approval_required: ["app_store_release", "privacy_changes"]

prompts:
  implementer: |
    You are building a production-ready mobile app with React Native and Expo.
    
    Requirements:
    - Follow React Native best practices and performance guidelines
    - Implement proper error boundaries and error handling
    - Use TypeScript for type safety
    - Implement offline-first architecture with sync capabilities
    - Follow iOS and Android design guidelines
    - Optimize for performance (60fps animations, efficient re-renders)
    - Implement comprehensive accessibility features
    - Use secure storage for sensitive data
    - Handle different screen sizes and orientations
    - Implement proper loading states and user feedback
    - Add proper analytics and crash reporting
    - Follow app store guidelines for both iOS and Android

scripts:
  setup: "npm install && npx expo install"
  start: "npx expo start"
  ios: "npx expo run:ios"
  android: "npx expo run:android"
  test: "npm test"
  test_e2e: "npm run test:e2e"
  build_ios: "eas build --platform ios"
  build_android: "eas build --platform android"
  submit_ios: "eas submit --platform ios"
  submit_android: "eas submit --platform android"
  lint: "eslint . --ext .js,.jsx,.ts,.tsx"
  type_check: "tsc --noEmit"

secrets:
  provider: "expo://env"
  required:
    - "SUPABASE_URL"
    - "SUPABASE_ANON_KEY"
    - "GOOGLE_CLOUD_VISION_API_KEY"
  optional:
    - "SENTRY_DSN"
    - "ANALYTICS_API_KEY"

metadata:
  estimated_effort: "8-12 weeks"
  complexity: "advanced"
  tags: ["mobile", "react-native", "expo", "expense-tracking", "ocr", "offline-first"]
  version: "1.0.0"
  app_store_category: "Finance"
  privacy_level: "high"
  maintainers:
    - name: "Mobile Team"
      email: "mobile-team@company.com"
```

## Features

### Core Features
- 📱 **Cross-Platform**: Single codebase for iOS and Android
- 📸 **Receipt Scanning**: AI-powered receipt OCR with data extraction
- 💰 **Expense Tracking**: Manual and automatic expense entry
- 🏷️ **Smart Categories**: AI-powered categorization with custom options
- 📊 **Budget Management**: Monthly and category-based budgets with alerts
- 📈 **Analytics & Reports**: Visual spending analysis and insights
- 🔄 **Offline Support**: Full offline functionality with cloud sync
- 🔐 **Secure Authentication**: Biometric login with app lock
- 🌍 **Multi-Currency**: Support for 150+ currencies with live rates
- 📍 **Location Tracking**: Automatic merchant detection

### Advanced Features
- 🤖 **AI Insights**: Spending pattern analysis and recommendations
- 🔔 **Smart Notifications**: Budget alerts and spending reminders
- 📤 **Export Capabilities**: CSV, PDF reports for tax preparation
- 👥 **Shared Expenses**: Split bills and group expense tracking
- 🏪 **Merchant Database**: Automatic merchant categorization
- 📅 **Recurring Expenses**: Subscription and recurring payment tracking
- 🎯 **Financial Goals**: Savings goals with progress tracking

## Architecture

### Project Structure

```
expense-tracker/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── common/          # Generic components
│   │   ├── forms/           # Form components
│   │   ├── charts/          # Chart components
│   │   └── camera/          # Camera/scanner components
│   ├── screens/             # Screen components
│   │   ├── auth/            # Authentication screens
│   │   ├── expenses/        # Expense management screens
│   │   ├── budgets/         # Budget management screens
│   │   ├── analytics/       # Analytics and reports screens
│   │   └── settings/        # Settings and profile screens
│   ├── navigation/          # Navigation configuration
│   ├── store/               # Redux store and slices
│   │   ├── slices/          # Redux toolkit slices
│   │   ├── api/             # RTK Query API slices
│   │   └── index.ts
│   ├── services/            # External services and APIs
│   │   ├── supabase/        # Supabase client and methods
│   │   ├── ocr/             # OCR processing service
│   │   ├── sync/            # Data synchronization
│   │   └── analytics/       # Analytics service
│   ├── utils/               # Utility functions
│   │   ├── database/        # Local SQLite operations
│   │   ├── formatting/      # Number and date formatting
│   │   ├── validation/      # Form validation
│   │   └── storage/         # Secure storage utilities
│   ├── hooks/               # Custom React hooks
│   ├── types/               # TypeScript type definitions
│   ├── constants/           # App constants and config
│   └── assets/              # Images, fonts, etc.
├── __tests__/               # Unit tests
├── e2e/                     # End-to-end tests
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── app.json                 # Expo configuration
├── eas.json                 # EAS Build configuration
├── package.json
└── tsconfig.json
```

### Database Schema (SQLite)

```sql
-- Local SQLite schema for offline storage
CREATE TABLE expenses (
    id TEXT PRIMARY KEY,
    amount REAL NOT NULL,
    currency TEXT DEFAULT 'USD',
    description TEXT,
    category_id TEXT,
    date DATETIME NOT NULL,
    location TEXT,
    merchant_name TEXT,
    receipt_image_path TEXT,
    notes TEXT,
    tags TEXT, -- JSON array
    is_recurring BOOLEAN DEFAULT FALSE,
    recurring_frequency TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    synced_at DATETIME,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE categories (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    color TEXT DEFAULT '#6B7280',
    icon TEXT DEFAULT 'folder',
    parent_id TEXT,
    budget_amount REAL,
    is_system BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    synced_at DATETIME
);

CREATE TABLE budgets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    amount REAL NOT NULL,
    period TEXT DEFAULT 'monthly', -- monthly, weekly, yearly
    category_ids TEXT, -- JSON array
    start_date DATETIME,
    end_date DATETIME,
    alert_percentage REAL DEFAULT 0.8,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    synced_at DATETIME
);

CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL, -- insert, update, delete
    data TEXT, -- JSON
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    attempts INTEGER DEFAULT 0,
    last_attempt_at DATETIME
);

-- Indexes for performance
CREATE INDEX idx_expenses_date ON expenses(date);
CREATE INDEX idx_expenses_category ON expenses(category_id);
CREATE INDEX idx_expenses_synced ON expenses(synced_at);
CREATE INDEX idx_sync_queue_status ON sync_queue(attempts, created_at);
```

## Key Implementation Examples

### Receipt Scanning with OCR

```tsx
{% raw %}
// src/components/camera/ReceiptScanner.tsx
import React, { useState } from 'react';
import { View, Text, TouchableOpacity, Alert } from 'react-native';
import { Camera, CameraView } from 'expo-camera';
import * as ImageManipulator from 'expo-image-manipulator';
import { OCRService } from '../../services/ocr/OCRService';
import { useExpenseStore } from '../../store/slices/expenseSlice';

interface ReceiptScannerProps {
  onScanComplete: (expenseData: any) => void;
  onCancel: () => void;
}

export const ReceiptScanner: React.FC<ReceiptScannerProps> = ({
  onScanComplete,
  onCancel,
}) => {
  const [isProcessing, setIsProcessing] = useState(false);
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [cameraRef, setCameraRef] = useState<Camera | null>(null);

  const { addExpense } = useExpenseStore();

  React.useEffect(() => {
    (async () => {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasPermission(status === 'granted');
    })();
  }, []);

  const capturePhoto = async () => {
    if (!cameraRef) return;

    try {
      setIsProcessing(true);
      
      // Capture photo
      const photo = await cameraRef.takePictureAsync({
        quality: 0.7,
        base64: true,
        exif: false,
      });

      // Optimize image for OCR
      const optimizedPhoto = await ImageManipulator.manipulateAsync(
        photo.uri,
        [
          { resize: { width: 1024 } }, // Reduce size for faster processing
        ],
        {
          compress: 0.8,
          format: ImageManipulator.SaveFormat.JPEG,
          base64: true,
        }
      );

      // Process with OCR
      const ocrResult = await OCRService.processReceipt(optimizedPhoto.base64!);
      
      if (ocrResult.success) {
        const expenseData = {
          amount: ocrResult.data.total,
          description: ocrResult.data.merchantName || 'Receipt scan',
          category_id: await predictCategory(ocrResult.data.items),
          date: ocrResult.data.date || new Date().toISOString(),
          merchant_name: ocrResult.data.merchantName,
          receipt_image_path: photo.uri,
          items: ocrResult.data.items,
        };

        onScanComplete(expenseData);
      } else {
        Alert.alert(
          'Scan Failed',
          'Could not extract data from receipt. Please try again or enter manually.',
          [
            { text: 'Retry', onPress: () => setIsProcessing(false) },
            { text: 'Manual Entry', onPress: onCancel },
          ]
        );
      }
    } catch (error) {
      console.error('Receipt scanning error:', error);
      Alert.alert('Error', 'Failed to process receipt. Please try again.');
    } finally {
      setIsProcessing(false);
    }
  };

  const predictCategory = async (items: any[]): Promise<string> => {
    // AI-powered category prediction based on receipt items
    const itemTexts = items.map(item => item.description?.toLowerCase()).join(' ');
    
    const categoryKeywords = {
      'food_dining': ['restaurant', 'cafe', 'pizza', 'burger', 'coffee', 'dining'],
      'groceries': ['grocery', 'market', 'produce', 'milk', 'bread', 'meat'],
      'gas': ['gas', 'fuel', 'shell', 'exxon', 'chevron', 'bp'],
      'shopping': ['store', 'mall', 'retail', 'clothing', 'shoes'],
      'healthcare': ['pharmacy', 'medical', 'doctor', 'hospital', 'cvs', 'walgreens'],
    };

    for (const [category, keywords] of Object.entries(categoryKeywords)) {
      if (keywords.some(keyword => itemTexts.includes(keyword))) {
        return category;
      }
    }

    return 'other';
  };

  if (hasPermission === null) {
    return <Text>Requesting camera permission...</Text>;
  }

  if (hasPermission === false) {
    return <Text>No access to camera</Text>;
  }

  return (
    <View style={{ flex: 1 }}>
      <CameraView
        ref={setCameraRef}
        style={{ flex: 1 }}
        facing="back"
        autofocus="on"
      >
        {/* Overlay UI */}
        <View style={styles.overlay}>
          <View style={styles.header}>
            <TouchableOpacity onPress={onCancel} style={styles.cancelButton}>
              <Text style={styles.buttonText}>Cancel</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.centerFrame}>
            <View style={styles.scanFrame} />
            <Text style={styles.instructionText}>
              Position receipt within frame
            </Text>
          </View>

          <View style={styles.footer}>
            <TouchableOpacity
              onPress={capturePhoto}
              disabled={isProcessing}
              style={[styles.captureButton, isProcessing && styles.disabled]}
            >
              <Text style={styles.captureButtonText}>
                {isProcessing ? 'Processing...' : 'Scan Receipt'}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Processing overlay */}
        {isProcessing && (
          <View style={styles.processingOverlay}>
            <Text style={styles.processingText}>
              Processing receipt...
            </Text>
          </View>
        )}
      </CameraView>
    </View>
  );
};
{% endraw %}
```

### Offline-First Data Management

```tsx
// src/services/sync/SyncService.ts
import { supabase } from '../supabase/client';
import { SQLiteService } from '../../utils/database/SQLiteService';
import NetInfo from '@react-native-async-storage/async-storage';

export class SyncService {
  private static instance: SyncService;
  private isOnline: boolean = true;
  private syncInProgress: boolean = false;

  public static getInstance(): SyncService {
    if (!SyncService.instance) {
      SyncService.instance = new SyncService();
    }
    return SyncService.instance;
  }

  constructor() {
    this.initializeNetworkListener();
  }

  private initializeNetworkListener() {
    NetInfo.addEventListener(state => {
      const wasOnline = this.isOnline;
      this.isOnline = state.isConnected ?? false;

      if (!wasOnline && this.isOnline) {
        // Just came online, trigger sync
        this.syncData();
      }
    });
  }

  async syncData(): Promise<{ success: boolean; error?: string }> {
    if (this.syncInProgress) {
      return { success: false, error: 'Sync already in progress' };
    }

    if (!this.isOnline) {
      return { success: false, error: 'No internet connection' };
    }

    this.syncInProgress = true;

    try {
      // Step 1: Push local changes to server
      await this.pushLocalChanges();

      // Step 2: Pull remote changes to local
      await this.pullRemoteChanges();

      // Step 3: Resolve conflicts if any
      await this.resolveConflicts();

      // Step 4: Clear sync queue
      await SQLiteService.clearSyncQueue();

      return { success: true };
    } catch (error) {
      console.error('Sync failed:', error);
      return { success: false, error: error.message };
    } finally {
      this.syncInProgress = false;
    }
  }

  private async pushLocalChanges() {
    const pendingChanges = await SQLiteService.getPendingSync();

    for (const change of pendingChanges) {
      try {
        switch (change.operation) {
          case 'insert':
          case 'update':
            await this.uploadRecord(change.table_name, JSON.parse(change.data));
            break;
          case 'delete':
            await this.deleteRecord(change.table_name, change.record_id);
            break;
        }

        // Mark as synced
        await SQLiteService.markSynced(change.table_name, change.record_id);
      } catch (error) {
        console.error(`Failed to sync ${change.table_name}:${change.record_id}`, error);
        
        // Increment attempt count
        await SQLiteService.incrementSyncAttempt(
          change.table_name, 
          change.record_id
        );
      }
    }
  }

  private async pullRemoteChanges() {
    const lastSyncTimestamp = await SQLiteService.getLastSyncTimestamp();

    // Fetch changes since last sync
    const tables = ['expenses', 'categories', 'budgets'];
    
    for (const table of tables) {
      const { data, error } = await supabase
        .from(table)
        .select('*')
        .gte('updated_at', lastSyncTimestamp)
        .order('updated_at', { ascending: true });

      if (error) {
        throw new Error(`Failed to fetch ${table}: ${error.message}`);
      }

      // Apply changes to local database
      for (const record of data || []) {
        await this.mergeRemoteRecord(table, record);
      }
    }

    // Update last sync timestamp
    await SQLiteService.setLastSyncTimestamp(new Date().toISOString());
  }

  private async mergeRemoteRecord(table: string, remoteRecord: any) {
    const localRecord = await SQLiteService.getRecord(table, remoteRecord.id);

    if (!localRecord) {
      // New record, insert locally
      await SQLiteService.insertRecord(table, remoteRecord, { skipSync: true });
    } else {
      // Check for conflicts
      const localUpdated = new Date(localRecord.updated_at);
      const remoteUpdated = new Date(remoteRecord.updated_at);

      if (remoteUpdated > localUpdated) {
        // Remote is newer, update local
        await SQLiteService.updateRecord(table, remoteRecord.id, remoteRecord, { skipSync: true });
      } else if (localUpdated > remoteUpdated && !localRecord.synced_at) {
        // Local is newer and unsynced, keep local version
        // Will be pushed in next sync
      }
      // If equal timestamps or local is synced, no action needed
    }
  }

  private async uploadRecord(table: string, record: any) {
    const { error } = await supabase
      .from(table)
      .upsert(record);

    if (error) {
      throw new Error(`Failed to upload to ${table}: ${error.message}`);
    }
  }

  private async deleteRecord(table: string, recordId: string) {
    const { error } = await supabase
      .from(table)
      .delete()
      .eq('id', recordId);

    if (error) {
      throw new Error(`Failed to delete from ${table}: ${error.message}`);
    }
  }

  async resolveConflicts() {
    // Implement conflict resolution strategy
    // For now, we use "last write wins" but this could be more sophisticated
    const conflicts = await SQLiteService.getConflicts();

    for (const conflict of conflicts) {
      // Use server version for conflicts
      await SQLiteService.resolveConflict(
        conflict.table_name,
        conflict.record_id,
        'server_wins'
      );
    }
  }
}
```

### Budget Management with Real-time Tracking

```tsx
// src/screens/budgets/BudgetOverview.tsx
import React, { useEffect } from 'react';
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { ProgressBar } from 'react-native-paper';
import { useBudgets, useExpenses } from '../../hooks';
import { BudgetCard } from '../../components/budgets/BudgetCard';
import { formatCurrency } from '../../utils/formatting/currency';

export const BudgetOverview: React.FC = () => {
  const { budgets, loading: budgetsLoading, fetchBudgets } = useBudgets();
  const { expenses, fetchExpensesByDateRange } = useExpenses();

  useEffect(() => {
    fetchBudgets();
    
    // Fetch current month's expenses for budget calculations
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);
    
    const endOfMonth = new Date();
    endOfMonth.setMonth(endOfMonth.getMonth() + 1);
    endOfMonth.setDate(0);
    endOfMonth.setHours(23, 59, 59, 999);
    
    fetchExpensesByDateRange(startOfMonth, endOfMonth);
  }, []);

  const calculateBudgetProgress = (budget: Budget) => {
    const relevantExpenses = expenses.filter(expense => {
      const expenseDate = new Date(expense.date);
      const budgetStart = new Date(budget.start_date);
      const budgetEnd = new Date(budget.end_date);

      // Check if expense is within budget period
      const inPeriod = expenseDate >= budgetStart && expenseDate <= budgetEnd;
      
      // Check if expense category matches budget
      const categoryMatch = budget.category_ids.includes(expense.category_id);

      return inPeriod && categoryMatch;
    });

    const spent = relevantExpenses.reduce((sum, expense) => sum + expense.amount, 0);
    const remaining = Math.max(0, budget.amount - spent);
    const progress = Math.min(1, spent / budget.amount);

    return {
      spent,
      remaining,
      progress,
      isOverBudget: spent > budget.amount,
    };
  };

  const checkBudgetAlerts = (budget: Budget, progress: any) => {
    const alertThreshold = budget.alert_percentage || 0.8;
    
    if (progress.progress >= alertThreshold && !progress.alertShown) {
      const message = progress.isOverBudget
        ? `You've exceeded your ${budget.name} budget by ${formatCurrency(progress.spent - budget.amount)}`
        : `You've used ${Math.round(progress.progress * 100)}% of your ${budget.name} budget`;

      Alert.alert('Budget Alert', message, [
        { text: 'OK', onPress: () => markAlertShown(budget.id) }
      ]);
    }
  };

  const renderBudgetItem = ({ item: budget }: { item: Budget }) => {
    const progress = calculateBudgetProgress(budget);
    
    // Check for alerts
    checkBudgetAlerts(budget, progress);

    return (
      <BudgetCard
        budget={budget}
        progress={progress}
        onPress={() => navigation.navigate('BudgetDetails', { budgetId: budget.id })}
        onEdit={() => navigation.navigate('EditBudget', { budgetId: budget.id })}
      />
    );
  };

  if (budgetsLoading) {
    return <LoadingSpinner />;
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Budgets</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => navigation.navigate('CreateBudget')}
        >
          <Text style={styles.addButtonText}>+ Add Budget</Text>
        </TouchableOpacity>
      </View>

      {budgets.length === 0 ? (
        <View style={styles.emptyState}>
          <Text style={styles.emptyStateText}>
            No budgets created yet
          </Text>
          <Text style={styles.emptyStateSubtext}>
            Create your first budget to track your spending
          </Text>
        </View>
      ) : (
        <FlatList
          data={budgets}
          renderItem={renderBudgetItem}
          keyExtractor={(item) => item.id}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.listContainer}
        />
      )}
    </View>
  );
};

// src/components/budgets/BudgetCard.tsx
export const BudgetCard: React.FC<BudgetCardProps> = ({
  budget,
  progress,
  onPress,
  onEdit,
}) => {
  const progressColor = progress.isOverBudget 
    ? '#EF4444' 
    : progress.progress > 0.8 
      ? '#F59E0B' 
      : '#10B981';

  return (
    <TouchableOpacity style={styles.card} onPress={onPress}>
      <View style={styles.cardHeader}>
        <View>
          <Text style={styles.budgetName}>{budget.name}</Text>
          <Text style={styles.budgetPeriod}>
            {formatDateRange(budget.start_date, budget.end_date)}
          </Text>
        </View>
        
        <TouchableOpacity onPress={onEdit} style={styles.editButton}>
          <Text style={styles.editButtonText}>Edit</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.progressSection}>
        <View style={styles.amountRow}>
          <Text style={styles.spentAmount}>
            {formatCurrency(progress.spent)} spent
          </Text>
          <Text style={styles.totalAmount}>
            of {formatCurrency(budget.amount)}
          </Text>
        </View>

        <ProgressBar
          progress={progress.progress}
          color={progressColor}
          style={styles.progressBar}
        />

        <View style={styles.remainingRow}>
          <Text style={[
            styles.remainingAmount,
            progress.isOverBudget && styles.overBudgetText
          ]}>
            {progress.isOverBudget
              ? `${formatCurrency(Math.abs(progress.remaining))} over budget`
              : `${formatCurrency(progress.remaining)} remaining`
            }
          </Text>
          <Text style={styles.progressPercentage}>
            {Math.round(progress.progress * 100)}%
          </Text>
        </View>
      </View>
    </TouchableOpacity>
  );
};
```

### Analytics Dashboard with Charts

```tsx
// src/screens/analytics/AnalyticsDashboard.tsx
import React, { useState, useEffect } from 'react';
import {
  View,
  ScrollView,
  Text,
  TouchableOpacity,
  Dimensions,
} from 'react-native';
import {
  LineChart,
  PieChart,
  BarChart,
} from 'react-native-chart-kit';
import { DateRangePicker } from '../../components/common/DateRangePicker';
import { useExpenses } from '../../hooks';
import { AnalyticsService } from '../../services/analytics/AnalyticsService';

const screenWidth = Dimensions.get('window').width;

export const AnalyticsDashboard: React.FC = () => {
  const [dateRange, setDateRange] = useState({
    start: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
    end: new Date(),
  });
  
  const [activeTab, setActiveTab] = useState('overview');
  const { expenses, fetchExpensesByDateRange } = useExpenses();
  const [analyticsData, setAnalyticsData] = useState<any>(null);

  useEffect(() => {
    fetchExpensesByDateRange(dateRange.start, dateRange.end);
  }, [dateRange]);

  useEffect(() => {
    if (expenses.length > 0) {
      const data = AnalyticsService.generateAnalytics(expenses, dateRange);
      setAnalyticsData(data);
    }
  }, [expenses]);

  const chartConfig = {
    backgroundGradientFrom: '#ffffff',
    backgroundGradientFromOpacity: 0,
    backgroundGradientTo: '#ffffff',
    backgroundGradientToOpacity: 0.5,
    color: (opacity = 1) => `rgba(99, 102, 241, ${opacity})`,
    strokeWidth: 2,
    barPercentage: 0.5,
    useShadowColorFromDataset: false,
  };

  if (!analyticsData) {
    return <LoadingSpinner />;
  }

  return (
    <ScrollView style={styles.container}>
      {/* Date Range Selector */}
      <View style={styles.dateRangeContainer}>
        <DateRangePicker
          startDate={dateRange.start}
          endDate={dateRange.end}
          onDateRangeChange={setDateRange}
        />
      </View>

      {/* Tab Navigation */}
      <View style={styles.tabContainer}>
        {['overview', 'trends', 'categories'].map((tab) => (
          <TouchableOpacity
            key={tab}
            style={[
              styles.tab,
              activeTab === tab && styles.activeTab
            ]}
            onPress={() => setActiveTab(tab)}
          >
            <Text style={[
              styles.tabText,
              activeTab === tab && styles.activeTabText
            ]}>
              {tab.charAt(0).toUpperCase() + tab.slice(1)}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* Overview Tab */}
      {activeTab === 'overview' && (
        <View style={styles.tabContent}>
          {/* Summary Cards */}
          <View style={styles.summaryGrid}>
            <View style={styles.summaryCard}>
              <Text style={styles.summaryAmount}>
                {formatCurrency(analyticsData.totalSpent)}
              </Text>
              <Text style={styles.summaryLabel}>Total Spent</Text>
            </View>
            
            <View style={styles.summaryCard}>
              <Text style={styles.summaryAmount}>
                {analyticsData.transactionCount}
              </Text>
              <Text style={styles.summaryLabel}>Transactions</Text>
            </View>
            
            <View style={styles.summaryCard}>
              <Text style={styles.summaryAmount}>
                {formatCurrency(analyticsData.avgTransaction)}
              </Text>
              <Text style={styles.summaryLabel}>Avg. Transaction</Text>
            </View>
            
            <View style={styles.summaryCard}>
              <Text style={styles.summaryAmount}>
                {formatCurrency(analyticsData.dailyAverage)}
              </Text>
              <Text style={styles.summaryLabel}>Daily Average</Text>
            </View>
          </View>

          {/* Category Breakdown Pie Chart */}
          <View style={styles.chartContainer}>
            <Text style={styles.chartTitle}>Spending by Category</Text>
            <PieChart
              data={analyticsData.categoryBreakdown}
              width={screenWidth - 32}
              height={220}
              chartConfig={chartConfig}
              accessor="amount"
              backgroundColor="transparent"
              paddingLeft="15"
              absolute
            />
          </View>
        </View>
      )}

      {/* Trends Tab */}
      {activeTab === 'trends' && (
        <View style={styles.tabContent}>
          {/* Daily Spending Trend */}
          <View style={styles.chartContainer}>
            <Text style={styles.chartTitle}>Daily Spending Trend</Text>
            <LineChart
              data={analyticsData.dailyTrend}
              width={screenWidth - 32}
              height={220}
              chartConfig={chartConfig}
              bezier
              style={styles.chart}
            />
          </View>

          {/* Weekly Comparison */}
          <View style={styles.chartContainer}>
            <Text style={styles.chartTitle}>Weekly Comparison</Text>
            <BarChart
              data={analyticsData.weeklyComparison}
              width={screenWidth - 32}
              height={220}
              chartConfig={chartConfig}
              style={styles.chart}
            />
          </View>
        </View>
      )}

      {/* Categories Tab */}
      {activeTab === 'categories' && (
        <View style={styles.tabContent}>
          {analyticsData.categoryDetails.map((category: any) => (
            <View key={category.id} style={styles.categoryRow}>
              <View style={styles.categoryInfo}>
                <View
                  style={[
                    styles.categoryColor,
                    { backgroundColor: category.color }
                  ]}
                />
                <View>
                  <Text style={styles.categoryName}>{category.name}</Text>
                  <Text style={styles.categoryTransactions}>
                    {category.transactionCount} transactions
                  </Text>
                </View>
              </View>
              
              <View style={styles.categoryAmount}>
                <Text style={styles.categoryAmountText}>
                  {formatCurrency(category.amount)}
                </Text>
                <Text style={styles.categoryPercentage}>
                  {category.percentage}%
                </Text>
              </View>
            </View>
          ))}
        </View>
      )}

      {/* Export Button */}
      <TouchableOpacity
        style={styles.exportButton}
        onPress={() => exportAnalytics(analyticsData, dateRange)}
      >
        <Text style={styles.exportButtonText}>
          Export Report
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
};
```

## Testing Strategy

### Unit Testing

```tsx
// __tests__/services/OCRService.test.ts
import { OCRService } from '../../src/services/ocr/OCRService';

jest.mock('@react-native-async-storage/async-storage', () =>
  require('@react-native-async-storage/async-storage/jest/async-storage-mock')
);

describe('OCRService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('processReceipt', () => {
    it('should extract data from receipt successfully', async () => {
      const mockBase64 = 'mock-base64-image-data';
      const mockResponse = {
        textAnnotations: [
          { description: 'WALMART\n$12.99\nGROCERIES\n2024-01-15' }
        ]
      };

      // Mock Google Vision API response
      global.fetch = jest.fn().mockResolvedValueOnce({
        ok: true,
        json: async () => ({ responses: [mockResponse] })
      });

      const result = await OCRService.processReceipt(mockBase64);

      expect(result.success).toBe(true);
      expect(result.data.merchantName).toContain('WALMART');
      expect(result.data.total).toBe(12.99);
      expect(result.data.date).toContain('2024-01-15');
    });

    it('should handle OCR processing errors gracefully', async () => {
      const mockBase64 = 'invalid-base64-data';
      
      global.fetch = jest.fn().mockRejectedValueOnce(new Error('API Error'));

      const result = await OCRService.processReceipt(mockBase64);

      expect(result.success).toBe(false);
      expect(result.error).toBe('Failed to process receipt');
    });
  });
});
```

### E2E Testing with Detox

```javascript
// e2e/expense-flow.e2e.js
describe('Expense Management Flow', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should add expense manually', async () => {
    // Navigate to add expense screen
    await element(by.id('add-expense-button')).tap();
    
    // Fill out expense form
    await element(by.id('amount-input')).typeText('25.99');
    await element(by.id('description-input')).typeText('Coffee shop');
    await element(by.id('category-picker')).tap();
    await element(by.text('Food & Dining')).tap();
    
    // Save expense
    await element(by.id('save-expense-button')).tap();
    
    // Verify expense was added
    await expect(element(by.text('$25.99'))).toBeVisible();
    await expect(element(by.text('Coffee shop'))).toBeVisible();
  });

  it('should scan receipt and create expense', async () => {
    // Navigate to receipt scanner
    await element(by.id('add-expense-button')).tap();
    await element(by.id('scan-receipt-button')).tap();
    
    // Grant camera permission if needed
    await device.grantPermissions(['camera']);
    
    // Mock receipt scanning (in real test, you'd use test receipt image)
    await element(by.id('capture-button')).tap();
    
    // Wait for processing
    await waitFor(element(by.id('expense-form')))
      .toBeVisible()
      .withTimeout(10000);
    
    // Verify extracted data
    await expect(element(by.id('amount-input'))).toHaveValue('12.99');
    await expect(element(by.id('description-input'))).toHaveValue('WALMART');
    
    // Save the expense
    await element(by.id('save-expense-button')).tap();
    
    // Verify expense appears in list
    await expect(element(by.text('$12.99'))).toBeVisible();
  });

  it('should create and track budget', async () => {
    // Navigate to budgets
    await element(by.id('budgets-tab')).tap();
    
    // Create new budget
    await element(by.id('add-budget-button')).tap();
    await element(by.id('budget-name-input')).typeText('Groceries');
    await element(by.id('budget-amount-input')).typeText('400');
    await element(by.id('category-picker')).tap();
    await element(by.text('Groceries')).tap();
    await element(by.id('save-budget-button')).tap();
    
    // Verify budget appears
    await expect(element(by.text('Groceries'))).toBeVisible();
    await expect(element(by.text('$400'))).toBeVisible();
    
    // Check progress bar is visible
    await expect(element(by.id('budget-progress-bar'))).toBeVisible();
  });
});
```

## Performance Optimizations

### React Native Performance

```tsx
// src/components/common/OptimizedFlatList.tsx
import React, { memo, useCallback } from 'react';
import { FlatList } from 'react-native';

interface OptimizedExpenseListProps {
  expenses: Expense[];
  onExpensePress: (expense: Expense) => void;
}

const ExpenseItem = memo<{ 
  item: Expense; 
  onPress: (expense: Expense) => void 
}>(({ item, onPress }) => {
  const handlePress = useCallback(() => {
    onPress(item);
  }, [item, onPress]);

  return (
    <ExpenseListItem
      expense={item}
      onPress={handlePress}
    />
  );
});

export const OptimizedExpenseList: React.FC<OptimizedExpenseListProps> = memo(({ 
  expenses, 
  onExpensePress 
}) => {
  const renderExpenseItem = useCallback(({ item }: { item: Expense }) => (
    <ExpenseItem
      item={item}
      onPress={onExpensePress}
    />
  ), [onExpensePress]);

  const keyExtractor = useCallback((item: Expense) => item.id, []);

  const getItemLayout = useCallback((data: any, index: number) => ({
    length: 80, // Fixed height for better performance
    offset: 80 * index,
    index,
  }), []);

  return (
    <FlatList
      data={expenses}
      renderItem={renderExpenseItem}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}
      removeClippedSubviews={true}
      maxToRenderPerBatch={10}
      updateCellsBatchingPeriod={50}
      initialNumToRender={20}
      windowSize={10}
    />
  );
});
```

### Bundle Size Optimization

```javascript
// metro.config.js
const { getDefaultConfig } = require('@expo/metro-config');

const config = getDefaultConfig(__dirname);

// Tree shaking for smaller bundles
config.resolver.platforms = ['ios', 'android', 'native'];

// Enable Hermes for better performance
config.transformer.hermesCommand = 'hermesc';

// Optimize assets
config.transformer.assetRegistryPath = 'react-native/Libraries/Image/AssetRegistry';

module.exports = config;
```

## App Store Deployment

### iOS Configuration

```json
// app.json
{
  "expo": {
    "name": "Expense Tracker",
    "slug": "expense-tracker",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "automatic",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#6366f1"
    },
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.company.expensetracker",
      "buildNumber": "1",
      "infoPlist": {
        "NSCameraUsageDescription": "This app needs access to your camera to scan receipts",
        "NSLocationWhenInUseUsageDescription": "This app needs location access to automatically detect merchants",
        "NSFaceIDUsageDescription": "Use Face ID to secure your expense data"
      }
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#6366f1"
      },
      "package": "com.company.expensetracker",
      "versionCode": 1,
      "permissions": [
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE",
        "ACCESS_FINE_LOCATION",
        "USE_FINGERPRINT",
        "USE_BIOMETRIC"
      ]
    },
    "web": {
      "favicon": "./assets/favicon.png"
    }
  }
}
```

### EAS Build Configuration

```json
// eas.json
{
  "cli": {
    "version": ">= 5.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "resourceClass": "m1-medium"
      }
    },
    "production": {
      "ios": {
        "resourceClass": "m1-medium"
      },
      "android": {
        "resourceClass": "medium"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "developer@company.com",
        "ascAppId": "1234567890",
        "appleTeamId": "XXXXXXXXXX"
      },
      "android": {
        "serviceAccountKeyPath": "./service-account-key.json",
        "track": "production"
      }
    }
  }
}
```

This comprehensive mobile app example demonstrates how OSpec can specify and generate a production-ready cross-platform mobile application with advanced features like OCR, offline support, real-time synchronization, and comprehensive analytics.