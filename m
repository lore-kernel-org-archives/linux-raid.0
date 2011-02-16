From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 13:25:00 -0500
Message-ID: <4D5C167C.7000101@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com> <4D5C15D3.1070608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C15D3.1070608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 01:22 PM, Phil Turmel wrote:
> On 02/16/2011 01:18 PM, Simon McNair wrote:
>> parted -l gives
>>
>> Error: The backup GPT table is not at the end of the disk, as it should be.  This might mean that another operating
>> system believes the disk is smaller.  Fix, by moving the backup to the end (and removing the old backup)?
>> Fix/Cancel? fix
>> Warning: Not all of the space available to /dev/sdb appears to be used, you can fix the GPT to use all of the space (an
>> extra 421296 blocks) or continue with the current setting?
>> Fix/Ignore?
>>
>> I'm guessing ignore ?
> 
> Either should work.  If you 'Fix' for all of the drives, you could later 'grow' your array to include the extra space.

It's vital that the start sector be 2048, though.  Please do recheck after all are done.

Phil
