From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Re: Antw: Problems creating MD-RAID1: "device .. not suitable
 for any style of raid array" / "Device or resource busy"
Date: Thu, 12 May 2011 08:07:54 +0200
Message-ID: <4DCB955A020000A100005D4A@gwsmtp1.uni-regensburg.de>
References: <4DCABB80020000A100005D46@gwsmtp1.uni-regensburg.de>
 <4DCAC0B3.8010509@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCAC0B3.8010509@anonymous.org.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> John Robinson <john.robinson@anonymous.org.uk> schrieb am 11.05.2011 um 19:00
in Nachricht <4DCAC0B3.8010509@anonymous.org.uk>:
> On 11/05/2011 15:38, Ulrich Windl wrote:
> > Hi!
> >
> > I could reduce the problem to "--bitmap internal": It works if I leave it 
> out. Unfortunately the RAID will fully resync every assembly when there was 
> an unclean shutdown.
> > The thing that kept one device busy was MD-RAID itself: "mdadm -- stop" 
> released the device.
> >
> > So to summarize:
> > 1) mdadm fails to set up an internal bitmap
> > 2) Even when mdadm fails to do 1), it starts the array
> 
> OK. First up, the syntax is "--bitmap=internal" - perhaps you have a 
> mdadm which is partially parsing what you've said but not got it 100% 
> right. If using the correct syntax doesn't work, instead try creating 
> the array without the bitmap, then adding one with
>    mdadm --grow /dev/mdX --bitmap=internal

Hi John!

Thanks for that. Of course (using my syntax) the "--grow" variant also did not work. I would also expect that mdadm can either handle "--bitmap internal" as a variant of "--bitmap=internal" or emit a syntax error. Unfortunately I don't have the time right now to inspect the sources.

Regards,
Ulrich
P.S. Amazing things happen now and then:
# cat /proc/mdstat
Personalities : [linear] [raid1]
md2 : active raid1 dm-17[1] dm-10[0]
      209715136 blocks [2/2] [UU]

md1 : active raid1 dm-12[0] dm-14[1]
      20971456 blocks [2/2] [UU]

md3 : active raid1 dm-16[0] dm-9[1]
      31457216 blocks [2/2] [UU]

md0 : active raid1 dm-11[0] dm-8[1]
      525336512 blocks [2/2] [UU]

unused devices: <none>
# mdadm --grow --bitmap=internal /dev/md0
# mdadm --grow --bitmap internal /dev/md1
# mdadm --grow --bitmap internal /dev/md2
# mdadm --grow --bitmap=internal /dev/md3
mdadm: failed to set internal bitmap.
# cat /proc/mdstat
Personalities : [linear] [raid1]
md2 : active raid1 dm-17[1] dm-10[0]
      209715136 blocks [2/2] [UU]
      bitmap: 0/200 pages [0KB], 512KB chunk

md1 : active raid1 dm-12[0] dm-14[1]
      20971456 blocks [2/2] [UU]
      bitmap: 0/160 pages [0KB], 64KB chunk

md3 : active raid1 dm-16[0] dm-9[1]
      31457216 blocks [2/2] [UU]

md0 : active raid1 dm-11[0] dm-8[1]
      525336512 blocks [2/2] [UU]
      bitmap: 0/126 pages [0KB], 2048KB chunk

unused devices: <none>


