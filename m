From: Luca Berra <bluca@comedia.it>
Subject: Re: strange RAID5 problem
Date: Tue, 9 May 2006 21:20:53 +0200
Message-ID: <20060509192053.GA27247@percy.comedia.it>
References: <4460290C.50202@harddata.com> <20060509055824.GB22085@percy.comedia.it> <4460C059.3070304@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4460C059.3070304@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 09, 2006 at 10:16:25AM -0600, Maurice Hilarius wrote:
>Luca Berra wrote:
>> On Mon, May 08, 2006 at 11:30:52PM -0600, Maurice Hilarius wrote:
>>> [root@box ~]# mdadm /dev/md3 -a /dev/sdw1
>>>
>>> But, I get this error message:
>>> mdadm: hot add failed for /dev/sdw1: No such device
>>>
>>> What? We just made the partition on sdw a moment ago in fdisk. It IS
>>> there!
>>
>> I don't believe you, prove it (/proc/partitions)
>>
>>
>I understand. Here we go then. Devices in question bracketed with "**":
>
ok, now i do.
is the /dev/sdw1 device file correctly created?
you could try straceing mdadm to see what happens

what about the other suggestion? trying to stop the array and restart
it, since it is marked as inactive.
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
