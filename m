From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Sun, 10 Jul 2011 18:44:21 -0500
Message-ID: <4E1A3955.7060207@hardwarefreak.com>
References: <20110706161228.GA1491@apartia.fr> <4E1494BB.9060101@turmel.org> <20110707090540.GA7288@apartia.fr> <4E15A980.3060508@turmel.org> <20110707130917.GA18812@apartia.fr> <4E15B576.9040004@turmel.org> <20110708054045.GA28420@maude.comedia.it> <20110710120350.GA30568@apartia.fr> <4E199AEB.4030606@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E199AEB.4030606@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/10/2011 7:28 AM, Phil Turmel wrote:
> On 07/10/2011 08:03 AM, Louis-David Mitterrand wrote:
>> On Fri, Jul 08, 2011 at 07:40:45AM +0200, Luca Berra wrote:
>>>> This is important.  When I computed the sector count for the linear mapping, I just took 2048 off the end.  You may want to select a sector count that aligns the endpoint.
>>> but the xfs sb should be at sector 0
>>
>> So what should I change to the dmsetup command to make it work?
> 
> He means (not to put words in Luca's mouth...) that the precise endpoint of the mapped volume shouldn't matter to fsck.xfs.  Changing device order in the raid is probably your only hope of recovery.  The dmsetup exercise was a blind alley.
> 
> Luca also pointed out that the problem array is named "grml" which means that it was created with grml, not your original system (zenon).  That suggests that "mdadm --create" was used under grml, and the member devices were specified in an order differing from the original install.  If that "mdadm --create" didn't include the "--assume-clean" option, then the parity blocks are almost certainly recomputed, and your data destroyed.  Otherwise, you can try "mdadm --create --assume-clean" with other combinations of device order to try to find the "right" one.
> 
> I recommend trying "mdadm --create --assume-clean" with the devices in the same order as shown by lsdrv for the zenon array.

Moral of this story:  Using live CDs to troubleshoot Linux RAID arrays,
LVM volumes, dmcrypt, etc, is tricky at best, fraught with disaster at
worst.  Always have a "system rescue" CD/DVD built from the particular
machine in question at the ready.  Most distros have a facility for
building such a per machine boot/rescue CD.  Such media will have the
same kernel and module versions, the system's mdadm configuration, and
all other system specific stuff needed to properly troubleshoot and repair.

If such rescue media had been used the OP would have likely experienced
far less grief, and might already had this problem fixed.

-- 
Stan
