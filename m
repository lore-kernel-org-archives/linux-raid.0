From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: User space RAID-6 access
Date: Tue, 01 Feb 2011 20:14:29 +0000
Message-ID: <4D4869A5.40608@anonymous.org.uk>
References: <20110131202054.GA15712@lazy.lzy> <20110201075259.4beaf501@notabene.brown> <20110201192154.GA2696@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201192154.GA2696@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/02/2011 19:21, Piergiorgio Sartor wrote:
> On Tue, Feb 01, 2011 at 07:52:59AM +1100, NeilBrown wrote:
>> On Mon, 31 Jan 2011 21:20:55 +0100 Piergiorgio Sartor
>> <piergiorgio.sartor@nexgo.de>  wrote:
>>
>>> Hi all,
>>>
>>> some times ago, I think was Neil, it was mentioned
>>> about the possibility to access consistently a RAID-6
>>> array from user space, in order to be able to perform
>>> some checks, like the notorius "which HDD has wrong data".
>>>
>>> Is there any reference or documentation or source code
>>> which can be taken as example for such a case?
>>>
>>
>> Look in the mdadm source code, particularly at restripe.c
>>
>> Also
>>     make test_stripe
>>
>> make a program the the test suite uses for verify data correctness.
>>
>> That should give you enough hints to get you started.
>
>
> Hi Neil, thanks for the pointer.
>
> I had a look at the code and there is something I did not get.
>
> It seems to me the HDDs composing the array are "simply"
> opened with "open".
>
> In case the array is in use, how is avoided a race condition
> between the "test_stripe" program and the md device?
>
> I mean, the first could start to read from the HDDs and the
> other could write something in the same place, leading to an
> inconsistent parity, from the "test_stripe" point of view,
> since it missed some update.
>
> Or there is a locking inside md (in "test_stripe" I could
> not see and it would also be dangerous)?

Look at Grow.c and suspend_lo and suspend_hi.

Just my =80$=A30.005, I may be wrong, etc.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
