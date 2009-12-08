From: ml-raid@syscall.eu
Subject: Possible bug
Date: Tue, 08 Dec 2009 14:18:24 +0100
Message-ID: <4B1E5220.8030500@syscall.eu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070400050305090502040400"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070400050305090502040400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hello,
I have a 2.6.27.29-4-grsec (from http://kernelsec.cr0.org) Linux box, on
x86, running debian lenny. On sunday, during the monthly rebuild of my
standard RAID1 setup (/proc/mdstat):

Personalities : [raid1]
md127 : active raid1 sda1[0] sdb1[1]
      488383936 blocks [2/2] [UU]

unused devices: <none>

The kernel started outputting thousands of backtraces (see attached log)
The IO throughput was drastically reduced but the resync finally
completed after about 38 hours.

This is the first time I have been bitten by this bug. The server has
been running on this kernel for 74 days and the previous resync didn't
exhibit any problem.

Unfortunately, the machine being used in production, I will probably not
be able to test possible fixes easily.

Regards,
Raphaël

--------------070400050305090502040400
Content-Type: text/plain;
 name="logall"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="logall"

 kernel: [6275442.463023] PAX: refcount overflow detected in: md127_resync:28139, uid/euid: 0/0                                                            
 kernel: [6275442.463076] PAX: refcount overflow occured at: sync_request+0x63f/0x720 [raid1]                                                              
 kernel: [6275442.463108] Modules linked in: i2c_dev usbhid hid ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables ipv6 aes_i586 aes_generic cbc dm_crypt crypto_blkcipher loop evdev i2c_i801 i2c_core pcspkr button intel_agp agpgart shpchp pci_hotplug ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod raid1 md_mod sd_mod ata_generic ata_piix piix libata scsi_mod dock ide_pci_generic ehci_hcd floppy uhci_hcd e1000 usbcore thermal processor fan [last unloaded: scsi_wait_scan]                                                                                                                                                   
 kernel: [6275442.463383]                                                                                                                                  
 kernel: [6275442.463402] Pid: 28139, comm: md127_resync Not tainted (2.6.27.29-4-grsec #1)                                                                
 kernel: [6275442.463435] EIP: 0060:[<f893bfff>] EFLAGS: 00000a02 CPU: 0                                                                                   
 kernel: [6275442.463462] EIP is at sync_request+0x63f/0x720 [raid1]                                                                                       
 kernel: [6275442.463483] EAX: c3d61000 EBX: 00000000 ECX: 00000080 EDX: f7189100                                                                          
 kernel: [6275442.463505] ESI: 00000000 EDI: c16e9d40 EBP: f74c3480 ESP: c2403e70                                                                          
 kernel: [6275442.463528]  DS: 0068 ES: 0068 FS: 00d8 GS: 0000 SS: 0068                                                                                    
 kernel: [6275442.463550] Process md127_resync (pid: 28139, ti=c2402000 task=f77620b0 task.ti=c2402000)                                                    
 kernel: [6275442.463576] Stack: 00000000 00000000 11219a78 00000000 c3d6b800 f7000d80 3a384b80 00000000                                                   
 kernel: [6275442.463629]        00000080 00000000 00000000 ffffffff 00000001 00000002 00000000 00001000                                                   
 kernel: [6275442.463683]        00000380 11219a00 00000000 f893b9c0 00000408 f8986168 c2403f98 00000000                                                   
 kernel: [6275442.463738] Call Trace:                                                                                                                      
 kernel: [6275442.463769]  [<f893b9c0>] sync_request+0x0/0x720 [raid1]                                                                                     
 kernel: [6275442.463800]  [<f8986168>] md_do_sync+0x958/0xd80 [md_mod]                                                                                    
 kernel: [6275442.463836]  [<f8989837>] __param_str_start_ro+0x436/0x1ea7 [md_mod]                                                                         
 kernel: [6275442.463873]  [<f8985730>] md_thread+0x0/0xe0 [md_mod]                                                                                        
 kernel: [6275442.463908]  [<f8985752>] md_thread+0x22/0xe0 [md_mod]                                                                                       
 kernel: [6275442.463941]  [<f8985730>] md_thread+0x0/0xe0 [md_mod]                                                                                        
 kernel: [6275442.463973]  [<c0438572>] kthread+0x42/0x70                                                                                                  
 kernel: [6275442.463999]  [<c0438530>] kthread+0x0/0x70                                                                                                   
 kernel: [6275442.464020]  [<c0404fe7>] kernel_thread_helper+0x7/0x10                                                                                      
 kernel: [6275442.464046]  =======================                                                                                                         
 kernel: [6275442.464064] Code: 2b 5c 24 08 1b 74 24 0c e9 ca fc ff ff 8b 42 0c 8b 4c 24 20 8b 40 44 8b 40 58 f0 01 88 90 01 00 00 71 08 f0 29 88 90 01 00 00 ce <89> d0 e8 6a 78 bb c7 8b 54 24 14 8b 42 08 e9 8b fe ff ff 8b 40                                                                                                           

--------------070400050305090502040400--
