From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Mon, 11 Jul 2011 06:49:47 -0500
Message-ID: <4E1AE35B.1020307@hardwarefreak.com>
References: <20110706161228.GA1491@apartia.fr> <4E1494BB.9060101@turmel.org> <20110707090540.GA7288@apartia.fr> <4E15A980.3060508@turmel.org> <20110707130917.GA18812@apartia.fr> <4E15B576.9040004@turmel.org> <20110708054045.GA28420@maude.comedia.it> <20110710120350.GA30568@apartia.fr> <4E199AEB.4030606@turmel.org> <4E1A3955.7060207@hardwarefreak.com> <20110711075729.GB32187@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110711075729.GB32187@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/11/2011 2:57 AM, Louis-David Mitterrand wrote:
> On Sun, Jul 10, 2011 at 06:44:21PM -0500, Stan Hoeppner wrote:
>>
>> Moral of this story:  Using live CDs to troubleshoot Linux RAID arrays,
>> LVM volumes, dmcrypt, etc, is tricky at best, fraught with disaster at
>> worst.  Always have a "system rescue" CD/DVD built from the particular
>> machine in question at the ready.  Most distros have a facility for
>> building such a per machine boot/rescue CD.  Such media will have the
>> same kernel and module versions, the system's mdadm configuration, and
>> all other system specific stuff needed to properly troubleshoot and repair.
>>
>> If such rescue media had been used the OP would have likely experienced
>> far less grief, and might already had this problem fixed.
> 
> A live CD like grml can properly auto-start a md array. My problem
> came from doing a --create instead of an --assemble at some point.

What did it not auto-start your md array in this case again?

-- 
Stan
