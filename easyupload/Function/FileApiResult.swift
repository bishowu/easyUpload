//
//  FileApiResult.swift
//  XnFun
//
//  Created by Justin on 2018/12/17.
//  Copyright © 2018年 ENIS. All rights reserved.
//

import Foundation

class FileApiResult {
    
    struct GetAccessTokenResult: Codable {
        var status: String
        var errno: Int
        var msg: String?
        var object: AccessTokenInfo?
    }
    
    struct AccessTokenInfo: Codable {
        var AccessToken: String
        var ExpiryTime: CLong
    }
    
    /// 已備份Device == 1/3 ==
    struct BackupDevicesResult: Codable {
        var errno: Int
        var objects: [BackupDevice]?    //0.95
        var object: [BackupDevice]?     //0.96
        var status: String
        var line: Int?                  //0.96
        var msg: String?                //0.96
    }
    
    /// 已備份Device == 2/3 ==
    struct BackupDevice: Codable {
        var Name: String
        var Path: String
        var folders: [BackupDeviceFolder]?  //0.95
        var Folders: [BackupDeviceFolder]?  //0.96
    }
    
    /// 已備份Device == 3/3 ==
    struct BackupDeviceFolder: Codable {
        var Count: Int
        var Cover: String
        var Name: String
        var Path: String?   //0.96
    }
    
    struct DiskSizeResult: Codable {
        var errno: Int
        var status: String
        var line: Int?
        var msg: String?
        var object: DiskSize
    }
    
    struct DiskSize: Codable {
        var Root: String
        var UsedRate: String
        var Used: Int64
        var Capacity: Int64
        var Available: Int64
    }
    
    /// 媒體檔案資料 == 1/2 ==
    struct MediasResult: Codable {
        var errno: Int
        var msg: String
        var object: [Media]?
        var IsDemo: Bool?
        var pageindex: Int?
        var pagesize: Int?
        var totalcount: Int?
        /* for Object Api */
        var total: Int?
    }
    
    /// 媒體檔案資料 == 2/2 ==
    struct Media: Codable {
        var ID: Int?
        var IMAGE_ID: String?
        var FACE_ID: String?
        var PATH: String?
        var FACE_RECOG_THUMBNAIL_PATH: String?
        var BIG_THUMBNAIL_PATH: String?
        var SMALL_THUMBNAIL_PATH: String?
        var FACE_DETECTION_INFO_FILE_PATH: String?
        var SIZE: Int64?
        var TIMESTAMP: CLong?
        var TITLE: String?
        var DURATION: String?
        var BITRATE: Int?
        var SAMPLERATE: Int?
        var CREATOR: String?
        var ARTIST: String?
        var ALBUM: String?
        var GENRE: String?
        var COMMENT: String?
        var CHANNELS: Int?
        var DISC: Int?
        var TRACK: Int?
        var DATE: String?
        var CREATE_TIME: String?
        var CHANGE_TIME: String?
        var ACCESS_TIME: String?
        var MODIFY_TIME: String?
        var RESOLUTION: String?
        var THUMBNAIL: Int?
        var ALBUM_ART: Int?
        var ROTATION: Int?
        var FOCUS_LENGTH: String?
        var F_NUMBER: String?
        var EXPOSURE_TIME: String?
        var ISO_SPEED_RATINGS: String?
        var FLASH: String?
        var MAKE: String?
        var MODEL: String?
        var DLNA_PN: String?
        var MIME: String?
        var GPS_LATITUDE_REF: String?
        var GPS_LATITUDE_ALL: String?
        var GPS_LATITUDE_DEGREE: Int?
        var GPS_LATITUDE_MINUTE: Int?
        var GPS_LATITUDE_SECOND_INT: Int?
        var GPS_LATITUDE_SECOND_POINT: Int?
        var GPS_LONGTITUDE_REF: String?
        var GPS_LONGTITUDE_ALL: String?
        var GPS_LONGTITUDE_DEGREE: Int?
        var GPS_LONGTITUDE_MINUTE: Int?
        var GPS_LONGTITUDE_SECOND_INT: Int?
        var GPS_LONGTITUDE_SECOND_POINT: Int?
        var SELFIE: Int?
        var SCANNED: Int?
        var FR_STATUS: Int?
        var REAL_TYPE: Int?
        var SCREENSHOT: Int?
        var GPS_LATITUDE_TODEGREE: Float?
        var GPS_LONGTITUDE_TODEGREE: Float?
     
        var NODE1: String?
        var NODE2: String?
    }
    
    struct NewDBMediasResult: Codable {
        var errno: Int
        var msg: String
        var object: [NewDBMedia]?
        var IsDemo: Bool?
        var pageindex: Int?
        var pagesize: Int?
        var totalcount: Int?
    }
    
    struct NewDBMedia: Codable {
        var id: Int?
        var image_id: String?
        var face_id: String?
        var path: String?
        var face_recog_thumbnail_path: String?
        var big_thumbnail_path: String?
        var small_thumbnail_path: String?
        var face_detection_info_file_path: String?
        var size: String?
        var timestamp: String?
        var title: String?
        var duration: String?
        var bitrate: Int?
        var samplerate: Int?
        var creator: String?
        var artist: String?
        var album: String?
        var genre: String?
        var comment: String?
        var channels: Int?
        var disc: Int?
        var track: Int?
        var date: String?
        var create_time: String?
        var change_time: String?
        var access_time: String?
        var modify_time: String?
        var resolution: String?
        var thumbnail: Int?
        var album_art: Int?
        var rotation: Int?
        var focus_length: String?
        var f_number: String?
        var exposure_time: String?
        var iso_speed_ratings: String?
        var flash: String?
        var make: String?
        var model: String?
        var dlna_pn: String?
        var mime: String?
        var gps_latitude_ref: String?
        var gps_latitude_all: String?
        var gps_latitude_degree: Int?
        var gps_latitude_minute: Int?
        var gps_latitude_second_int: Int?
        var gps_latitude_second_point: Int?
        var gps_longtitude_ref: String?
        var gps_longtitude_all: String?
        var gps_longtitude_degree: Int?
        var gps_longtitude_minute: Int?
        var gps_longtitude_second_int: Int?
        var gps_longtitude_second_point: Int?
        var selfie: Int?
        var scanned: Int?
        var fr_status: Int?
        var real_type: Int?
        var screenshot: Int?
        var gps_latitude_todegree: Float?
        var gps_longtitude_todegree: Float?
    
        var node1: String?
        var node2: String?
    }
    
    /// 刪除雲端檔案結果 == 1/2 ==
    struct DeleteFileResult: Codable {
        var errno: Int
        var file: String
        var line: Int
        var msg: String
        var object: DeleteFileObject?
        var status: String
    }
    
    /// 刪除雲端檔案結果 == 2/2 ==
    struct DeleteFileObject: Codable {
        var SuccessId: [Int]?
        var SuccessPath: [String]?
        var FailedId: [Int]?
        var FailedPath: [String]?
    }
    
    /// 備份檔案結果 == 1/2 ==
    struct BackupFileResult: Codable {
        var errno: Int
        var file: BackupFile?
        var status: String
    }
    
    /// 備份檔案結果 == 2/2 ==
    struct BackupFile: Codable {
        var name: String?
        var dir: String?
    }
    
    /// 取得日期結果 == 1/2 ==
    struct DateListResult: Codable {
        var errno: Int
//        var status: String
//        var line: Int
        var msg: String
//        var file: String
        var totalcount: Int
        var object: [DateListObject]?
    }
    
    /// 取得日期結果 == 2/2 ==
    struct DateListObject: Codable {
        var TimeItem: String?
    }
    
    struct NewDateListResult: Codable {
        var errno: Int
//        var status: String
//        var line: Int
        var msg: String
//        var file: String
        var totalcount: Int
        var object: [NewDateListObject]?
    }
    
    struct NewDateListObject: Codable {
        var timeitem: String?
    }
    
    /// 取得Root結果 == 1/2 ==
    struct GetRootResult: Codable {
        var errno: Int
        var object: Root?
        var status: String
        var line: Int
        var msg: String
        var file: String
    }
    
    /// 取得Root結果 == 2/2 ==
    struct Root: Codable {
        var root: String?
    }
    
    /// 取得硬碟label結果 == 1/1 ==
    struct DiskLabelListResult: Codable {
        var errno: Int
        var msg: String
        var object: [String:String]?
    }
    
    struct NewDBDiskLabelListResult: Codable {
        var errno: Int
        var msg: String?
        var object: LabelNickname?
    }

    struct LabelNickname: Codable {
        var DriveC: String?
        var DriveD: String?
        var DriveE: String?
        var DriveF: String?
    }
    
    /// 查詢檔案Detail結果
    struct QueryFileResult: Codable {
        var errno: Int
        var status: String
        var line: Int
        var file: String
        var object: [Media]?
    }
    
    struct NewDBQueryFileResult: Codable {
        var errno: Int
        var status: String
        var line: Int
        var file: String
        var object: [NewDBMedia]?
    }
    
    /// 比對檔案的MD5
    struct CheckMD5Result: Codable {
        var errno: Int
        var status: String?
        var object: String?
    }
    
    /// 比對Path, size and return MD5
    struct QueryFileAndMD5Result: Codable {
        var errno: Int
        var status: String
        var object: QueryFileAndMD5?
    }
    
    struct QueryFileAndMD5: Codable {
        var exist: Bool
        var size: String?
        var md5: String?
    }
    
    // Object detected list
    struct ObjectDetectedListResult: Codable {
        var errno: Int
        var totalcount: Int?
        var object: [ObjectClass]?
    }
    
    struct ObjectClass: Codable {
        var ID: Int
        var NAME: String
        var object: [Media]?
    }
    
    struct NewDBObjectDetectedListResult: Codable {
        var errno: Int
        var totalcount: Int?
        var object: [NewDBObjectClass]?
    }
    
    struct NewDBObjectClass: Codable {
        var object_list_id: String
        var name: String
        var object: [NewDBMedia]?
    }
    
    enum SupportedObjectIDs: Int {
        case BICYCLE = 2, CAR = 3, MOTORCYCLE = 4, CAT = 17, DOG = 18, EMPTY = 0, FACE = -1
        
        func getIcon() -> String {
            var icon = ""
            switch self {
            case .BICYCLE:
                icon = "icon_bicycle_grey.svg"
                break
            case .CAR:
                icon = "icon_car_grey.svg"
                break
            case .MOTORCYCLE:
                icon = "icon_motorcycle_grey.svg"
                break
            case .CAT:
                icon = "icon_cat_grey.svg"
                break
            case .DOG:
                icon = "icon_dog_grey.svg"
                break
            case .EMPTY:
                icon = "ci_empty_ai"
                break
            case .FACE:
                icon = ""
                break
            }
                
            return icon
        }
    }
    
    struct ObjClassItem {
        var ID: Int
        var Nickname: String
    }
    
    /* Manual Album List */
    struct ManualAlbumListResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var total: Int?
        var object: [ManualAlbumItem]?
        var count: Int?
        var pageindex: Int?
        var pagesize: Int?
        var itemindex: Int?
        var itemsize: Int?
        var file: String?
    }
    
    /* Manual Album Item */
    struct ManualAlbumItem: Codable {
        var AlbumID: String?
        var AlbumName: String?
        var CreateTime: CLong?
        var ShareLink: String?
        var EnableShare: Bool?
        var total: Int?
        var count: Int?
        var Item: [ManualImageItem]?
    }
    
    /* Manual Image Item */
    struct ManualImageItem: Codable {
        var ImageID: String?
        var CreateTime: CLong?
        var Sequence: CLong?
        var Owner: String?
        var id: Int?
        var image_id: String?
        var path: String?
        var face_recog_thumbnail_path: String?
        var big_thumbnail_path: String?
        var small_thumbnail_path: String?
        var face_detection_info_file_path: String?
        var size: String?
        var timestamp: String?
        var title: String?
        var duration: String?
        var bitrate: Int?
        var samplerate: Int?
        var creator: String?
        var artist: String?
        var album: String?
        var genre: String?
        var comment: String?
        var channels: Int?
        var disc: Int?
        var track: Int?
        var date: String?
        var resolution: String?
        var thumbnail: Int?
        var album_art: Int?
        var rotation: Int?
        var focus_length: String?
        var f_number: String?
        var exposure_time: String?
        var iso_speed_ratings: String?
        var flash: String?
        var make: String?
        var model: String?
        var dlna_pn: String?
        var mime: String?
        var gps_latitude_ref: String?
        var gps_latitude_all: String?
        var gps_latitude_degree: Int?
        var gps_latitude_minute: Int?
        var gps_latitude_second_int: Int?
        var gps_latitude_second_point: Int?
        var gps_longtitude_ref: String?
        var gps_longtitude_all: String?
        var gps_longtitude_degree: Int?
        var gps_longtitude_minute: Int?
        var gps_longtitude_second_int: Int?
        var gps_longtitude_second_point: Int?
        var selfie: Int?
        var scanned: Int?
        var fr_status: Int?
        var real_type: Int?
        var screenshot: Int?
        var create_time: String?
        var change_time: String?
        var access_time: String?
        var modify_time: String?
        var node1: String?
        var node2: String?
        var animation_info_file_path: String?
        var deleted: Int?
        var gps_latitude_todegree: Float?
        var gps_longtitude_todegree: Float?
    }
    
    /* Manual Album Remove Result */
    struct ManualAlbumRemoveResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
    }
    
    /* Album Setting Result */
    struct AlbumSettingResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var object: AlbumSettingItem?
    }
    
    /* Album Setting Item */
    struct AlbumSettingItem: Codable {
        var AlbumID: String?
        var EnableShare: Bool?
        var EnableUpload: Bool?
        var RequirePassword: Bool?
        var EnablePublic: Bool?
        var ShareLink: String?
        var Password: String?
    }
    
    /* Album Share Result */
    struct AlbumShareResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var object: AlbumShareItem?
    }
    
    /* Album Share Item */
    struct AlbumShareItem: Codable {
        var ShareLink: String?
    }
    
    struct CreateAlbumReturn: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
        var line: Int?
        var file: String?
        var object: [AlbumCreate]?
    }
    
    struct AlbumCreate: Codable {
        var AlbumID: String?
        var Name: String?
        var EnableShare: Bool?
        var EnableUpload: Bool?
        var RequirePassword: Bool?
        var EnablePublic: Bool?
    }
    
    struct DeleteAlbumReturn: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
    }
    
    struct AlbumUpdate: Codable {
        var AlbumName: String?
    }
    
    /* Manual Album update */
    struct  ManualAlbumUpdateResult: Codable {
           var status: String?
           var errno: Int?
           var line: Int?
           var msg: String?
    }
    
    struct AddAlbumItemReturn: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
        var CountAdd: Int?
        var CountIgnore: Int?
    }
    
    
    /*
        FW Upgrade API
        RouteName = fwupgrade
     */
    
    struct FWApiReturn: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
    }
    
    // Check FW version
    struct FWCheckResult: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
        var object: FWInfo?
    }
    
    struct FWInfo: Codable {
        var version: String?
        var changelog: FWChangelog?
    }
    
    struct FWChangelog: Codable {
        var en: [String]?
    }
    
    
    /*
        FW download info
  "nsc":{"0":{"name":"BCM7252S-000068-Debian7-011-001-20191024.tar.gz","size":1608,"checksum":"9425ed56550faa0a88ed590238c6368d"},"1":{"name":"BCM7252S-000068-Romfs-011-001-20191024.tar.gz","size":674756878,"checksum":"2fabb6a11303619feec12597121133c9"}},"total_size":674758486}
     
     */
    
    struct FWDownloadResult: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
        var object: FWDownloadNscInfo?
    }
    
    struct FWDownloadNscInfo: Codable {
        var nsc: [DownloadFileInfo]?
        var total_size: Int64?
    }
    
    struct DownloadFileInfo: Codable {
        var name: String
        var size: Int64
        var checksum: String
        
        func toJSON() -> [String : Any] {
            return [
                "name": self.name,
                "size": self.size,
                "checksum": self.checksum
            ]
        }
    }
    
    // FW download progress
    struct FWDownloadProgress: Codable {
        var errno: Int?
        var msg: String?
        var status: String?
        var object: DownloadProgress?
    }
    
    struct DownloadProgress: Codable {
        var size: Int64
        var total: Int64
    }
    
    /* Face Group List */
    struct FaceGroupListResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var pagesize: Int?
        var pageindex: Int?
        var totalcount: Int?
        var object: [FaceGroupItem]?
    }
    
    /* Face Group Item */
    struct FaceGroupItem: Codable {
        var ID: Int?
        var GROUP_ID: String?
        var NAME: String?
        var USER_TAG: String?
        var AVATAR: String?
        var ENABLE: Int?
        var IMAGE_QUANTITY: Int?
    }
    
    /* Face Group List FW 1.0 */
    struct FaceGroupListFW1Result: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var pagesize: Int?
        var pageindex: Int?
        var totalcount: Int?
        var object: [FaceGroupFW1Item]?
    }
    
    /* Face Group item FW 1.0 */
    struct FaceGroupFW1Item: Codable {
        var id: Int?
        var group_id: String?
        var name: String?
        var user_tag: String?
        var avatar: String?
        var enable: Int?
        var image_quantity: Int?
    }
    
    /* Face Setting Result */
    struct FaceSettingResult: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var object: FaceSettingItem?
    }
    
    /* Face Setting Item */
    struct FaceSettingItem: Codable {
        var Status: String?
        var onoffstatus: String?
    }
    
    /* Face Setting Result FW 1.0 */
    struct FaceSettingFW1Result: Codable {
        var status: String?
        var errno: Int?
        var line: Int?
        var msg: String?
        var object: FaceSettingFW1Item?
    }
    
    /* Face Setting Item FW 1.0 */
    struct FaceSettingFW1Item: Codable {
        var Status: String?
        var onoffstatus: Int?
    }
    
}
