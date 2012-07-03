From: Christian Balzer <chibi@gol.com>
Subject: Re: Fatal crash/hang in scsi_lib after RAID disk failure
Date: Tue, 3 Jul 2012 16:12:00 +0900
Message-ID: <20120703161200.2904740f@batzmaru.gol.ad.jp>
References: <20120629093552.1651d3c2@batzmaru.gol.ad.jp>
	<20120703155045.570a2bee@notabene.brown>
	<20120703151038.428af28f@batzmaru.gol.ad.jp>
	<20120703164528.5b9b4a7c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703164528.5b9b4a7c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Jul 2012 16:45:28 +1000 NeilBrown wrote:

> On Tue, 3 Jul 2012 15:10:38 +0900 Christian Balzer <chibi@gol.com> wrote:
> 
> > On Tue, 3 Jul 2012 15:50:45 +1000 NeilBrown wrote:
> > 
[snip]
> > > That took *way* to long to find given how simple the fix is.
> > 
> > Well, given how long it takes with some OSS projects, I'd say 4 days is
> > pretty good. ^o^
> 
> I meant the 4 hours of my time searching, not the 4 days of your time
> waiting :-)
> 
Hehehe, if you put it that way... ^o^

> 
> > 
> > > I spent ages staring at the code, as about to reply and so "no idea"
> > > when I thought I should test it myself.  Test failed immediately.
> > 
> > Could you elaborate a bit? 
> > As in, was this something introduced only very recently, since I had
> > dozens of disks fail before w/o any such pyrotechnics. 
> > Or were there some special circumstances that triggered it? 
> > (But looking at the patch, I guess it should have been pretty
> > universal)
> 
> Bug was introduced by commit 58c54fcca3bac5bf9 which first appeared in
> Linux 3.1.  Since then, any read error on RAID10 will trigger the bug.
> 
Ouch, that's a pretty substantial number of machines I'd reckon.

But now I'm even more intrigued, how do you (or the md code) define a read
error then? 
Remember this beauty here, which triggered the hunt and kill of the R10
recovery bug of uneven member sets?
---
Jun 20 18:22:01 borg03b kernel: [1383357.792044] mptscsih: ioc0: attempting task abort! (sc=ffff88023c3c5180)
Jun 20 18:22:01 borg03b kernel: [1383357.792049] sd 8:0:3:0: [sdh] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
Jun 20 18:22:06 borg03b kernel: [1383362.317346] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0
x0000) cb_idx mptscsih_io_done
Jun 20 18:22:06 borg03b kernel: [1383362.317589] mptscsih: ioc0: task abort: SUCCESS (rv=2002) (sc=ffff88023c3c5180)
Jun 20 18:22:06 borg03b kernel: [1383362.567292] mptbase: ioc0: LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay
 Retry}, SubCode(0x0000) cb_idx mptscsih_io_done
Jun 20 18:22:06 borg03b kernel: [1383362.567316] mptscsih: ioc0: attempting target reset! (sc=ffff88023c3c5180)
Jun 20 18:22:06 borg03b kernel: [1383362.567321] sd 8:0:3:0: [sdh] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
Jun 20 18:22:06 borg03b kernel: [1383362.568040] mptscsih: ioc0: target reset: SUCCESS (sc=ffff88023c3c5180)
Jun 20 18:22:06 borg03b kernel: [1383362.568068] mptscsih: ioc0: attempting host reset! (sc=ffff88023c3c5180)
Jun 20 18:22:06 borg03b kernel: [1383362.568074] mptbase: ioc0: Initiating recovery
Jun 20 18:22:29 borg03b kernel: [1383385.440045] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88023c3c5180)
Jun 20 18:22:29 borg03b kernel: [1383385.484846] Device returned, unsetting inDMD
Jun 20 18:22:39 borg03b kernel: [1383395.448043] sd 8:0:3:0: Device offlined - not ready after error recovery
Jun 20 18:22:39 borg03b kernel: [1383395.448135] sd 8:0:3:0: rejecting I/O to offline device
Jun 20 18:22:39 borg03b kernel: [1383395.452063] end_request: I/O error, dev sdh, sector 71
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md: super_written gets error=-5, uptodate=0
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Disk failure on sdh1, disabling device.
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Operation continuing on 4 devices.
---
That was a 3.2.18 kernel, but it didn't die and neither did the other
cluster member with a very similar failure two weeks earlier. 

So I guess the device getting kicked out by the libsata layer below is
fine, but it returning medium errors triggers the bug?

Anyways, time to patch stuff, thankfully this is the only production
cluster I have with a 3.2 kernel using RAID10. ^.^;

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
