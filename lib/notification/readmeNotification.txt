Android>app>main>AndroidMainfest.xml
-------------------------------------
add these lines :
inside <manifest>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
after  </activity>
add these lines :
 <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
           <intent-filter>
               <action android:name="android.intent.action.BOOT_COMPLETED"></action>
           </intent-filter>
  </receiver>
  <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
----------------------------------------------------------------------------------

in pubspec.yaml
----------------
dependencies:
rxdart: ^0.24.1
awesome_notifications: any
flutter_ringtone_player: ^3.0.0

