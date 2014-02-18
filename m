From: Phil Turmel <philip@turmel.org>
Subject: Re: QNAP 8 port RAID5 md0 recovery of missing MBR and md superblocks
Date: Tue, 18 Feb 2014 07:59:56 -0500
Message-ID: <5303594C.5010408@turmel.org>
References: <52CBF747.7020505@epos-cat.de> <A2EC67620EC7424F9EC3DD49243E9060466DC09B@AUDIINSX0328.audi.vwg> <A2EC67620EC7424F9EC3DD49243E9060466EC018@AUDIINSX0328.audi.vwg> <530212E5.2030003@turmel.org> <A2EC67620EC7424F9EC3DD49243E9060466EC088@AUDIINSX0328.audi.vwg> <53026150.2080806@turmel.org> <A2EC67620EC7424F9EC3DD49243E9060466EC7EE@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466EC7EE@AUDIINSX0328.audi.vwg>
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Michael,

[Please don't top post.  Trim & reply inline or bottom.]

On 02/18/2014 07:16 AM, Samer, Michael (I/ET-83, extern) wrote:

> Here's the actual examine of the target machine (I'm using a
> different one so disk designation is different as the target machine
> has only V2.6.3 available):

[trim /]

We'll need more information on the new platform, w/ all disks involved.
 Please start with "lsdrv >tree.txt" [1] and then "gdisk -l" for all
disks.  Consider including "smartdrv -x" for all as well.

Phil

[1] https://github.com/pturmel/lsdrv
