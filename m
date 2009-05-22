From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: Raid and badblocks
Date: Fri, 22 May 2009 10:19:48 +0100
Message-ID: <gv5qnk$1pe$1@ger.gmane.org>
References: <gv5q3p$vof$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

PS, here are some more data from the logs:

3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.                                          
sd 4:0:8:0: [sdj] Unhandled sense code                                                                 
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK                           
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]                                                   
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error                                                   
end_request: I/O error, dev sdj, sector 1953102848                                                     
3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.                                          
sd 4:0:8:0: [sdj] Unhandled sense code                                                                 
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK                           
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]                                                   
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error                                                   
end_request: I/O error, dev sdj, sector 1953102856                                                     
Buffer I/O error on device sdj, logical block 244137857                                                
Buffer I/O error on device sdj, logical block 244137858                                                
Buffer I/O error on device sdj, logical block 244137859                                                
Buffer I/O error on device sdj, logical block 244137860                                                
Buffer I/O error on device sdj, logical block 244137861
Buffer I/O error on device sdj, logical block 244137862
Buffer I/O error on device sdj, logical block 244137863
Buffer I/O error on device sdj, logical block 244137864
Buffer I/O error on device sdj, logical block 244137865
Buffer I/O error on device sdj, logical block 244137866
3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
sd 4:0:8:0: [sdj] Unhandled sense code
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 1953103080
3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
sd 4:0:8:0: [sdj] Unhandled sense code
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 1953103080
3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
sd 4:0:8:0: [sdj] Unhandled sense code
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 1953103080
__ratelimit: 24 callbacks suppressed
Buffer I/O error on device sdj, logical block 244137885
3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
sd 4:0:8:0: [sdj] Unhandled sense code
sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
end_request: I/O error, dev sdj, sector 1953103080
Buffer I/O error on device sdj, logical block 244137885
md: requested-resync of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for requested-resync.
md: using 128k window, over a total of 976551040 blocks.
md: md0: requested-resync done.


-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/



