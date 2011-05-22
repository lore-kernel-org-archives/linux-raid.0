From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 07:19:50 +0800
Message-ID: <4DD99A16.5010108@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9633E.5000101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/11 03:25, Stan Hoeppner wrote:
> On 5/22/2011 5:09 AM, Brad Campbell wrote:
>> On 22/05/11 17:04, Stan Hoeppner wrote:
>>
>>> WD's Green drives have a 5400 rpm 'variable' spindle speed.  The Seagate
>>> 2.5" SAS drive has a 7.2k spindle speed.
>>
>> Actually, I'm pretty sure the WD drives have a 5400 rpm spindle speed
>> period. I've got 15 of them here and I have no evidence of any form of
>> spindle speed variation. They say the drives have spindle speed :
>> "intellipower" which is marketspeak for slow enough to save a few watts,
>> but fast enough to do the job.
>
> From:  http://www.anandtech.com/show/2385/2
>
> The Western Digital drive's IntelliPower algorithm, which varies the
> rotational speed between 5400RPM and 7200RPM, dictates the Western
> Digital's rotational speed.

"In 2007 Western Digital announced the WD GP drive touting rotational 
speed "between 7200 and 5400 rpm", which, if potentially misleading, is 
technically correct; the drive spins at 5405 rpm, and the Green Power 
spin speed is not variable.[citation needed]"

http://en.wikipedia.org/wiki/Western_Digital

They're not variable. Or to put it another way, if they _can_ vary the 
spindle speed none of mine ever do.

Can you imagine the potential vibration nightmare as 10 drives vary 
their spindle speed up and down? Not to mention the extra load on the 
+12V rail and the delays while waiting for the platters to reach servo lock?

> IIRC from discussions here, mdadm has alignment issues with hybrid
> sector size drives when assembling raw disks.  Not everyone assembles
> their md devices from partitions.  Many assemble raw devices.

Which means the data starts at sector 0. That's an even multiple of 8. 
Job done. (Mine are all assembled raw also).

> You must boot your server with MD-DOS or FreeDOS and run wdidle3 once
> for each Green drive in the system.  But, IIRC, if the drives are
> connected via SAS expander or SATA PMP, this will not work.  A direct
> connection to the HBA is required.

Indeed. In my workshop I have an old machine with 3 SATA hotswap bays 
that allowed me to do 3 at once, booting off a USB key into DOS.

> Once one accounts for all the necessary labor and configuration
> contortions one must put himself through to make a Green drive into a
> 'regular' drive, it is often far more cost effective to buy 'regular'
> drives to begin with.  This saves on labor $$ which is usually greater,
> from a total life cycle perspective, than the drive acquisition savings.
>  The drives you end up with are already designed and tuned for the
> application.  Reiterating Rudy's earlier point, using the Green drives
> in arrays is "penny wise, pound foolish".
>

I agree with you. If I were doing it again I'd spend some extra $$$ on 
better drives, but I've already outlaid the cash and have a working array.

> Google WD20EARS and you'll find a 100:1 or more post ratio of problems
> vs praise for this drive.  This is the original 2TB model which has
> shipped in much greater numbers into the marketplace than all other
> Green drives.  Heck, simply search the archives of this list.

Indeed, but the same follows for almost any drive. People are quick to 
voice their discontent but not so quick to praise something that does 
what it says on the tin.

> And that backup array may fail you when you need it most:  during a
> restore.  Search the XFS archives for the horrific tale at University of
> California Santa Cruz.  The SA lost ~7TB of doctoral student research
> data due to multiple WD20EARS drives in his primary storage arrays *and*
> his D2D backup array dying in quick succession.  IIRC multiple grad
> students were forced to attend another semester to redo their
> experiments and field work to recreate the lost data, so they could then
> submit their theses.
>

Perhaps. Mine get a SMART short test every morning, a LONG every Sunday 
and a complete array scrub every other Sunday. My critical backups are 
also replicated to a WD World Edition Mybook that lives in another building.

I've had quite a few large arrays over the years, all comprised of the 
cheapest available storage at the time. I've had drives fail, but aside 
from a Sil3124 controller induced array failure I've never lost data 
because of a cheap hard disk and I've saved many, many, many $$$ on drives.

I'm not arguing the penny wise, pound foolish sentiment. I'm just 
stating my personal experience has been otherwise with drives.

