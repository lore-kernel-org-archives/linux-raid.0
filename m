From: Martin Seebach <mail@martinseebach.dk>
Subject: Fwd: Error on /dev/sda, but takes down RAID-1
Date: Wed, 23 Jan 2008 10:05:42 -0500 (EST)
Message-ID: <15672009.1331201100742126.JavaMail.root@zimbra>
References: <27710945.1301201097639436.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27710945.1301201097639436.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

I'm not sure this is completely linux-raid related, but I can't figure out where to start: 

A few days ago, my server died. I was able to log in and salvage this content of dmesg: 
http://pastebin.com/m4af616df 

I talked to my hosting-people and they said it was an io-error on /dev/sda, and replaced that drive. 
After this, I was able to boot into a PXE-image and re-build the two RAID-1 devices with no problems - indicating that sdb was fine. 

I expected RAID-1 to be able to stomach exactly this kind of error - one drive dying. What did I do wrong? 

Regards, 
Martin Seebach 


