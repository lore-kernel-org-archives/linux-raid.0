From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Mon, 03 Dec 2012 14:44:52 -0600
Message-ID: <50BD0F44.7010808@genband.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>	<50B67230.4080602@genband.com> <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com> <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BD09EC.5060705@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2012 02:22 PM, Ric Wheeler wrote:
> On 11/28/2012 03:29 PM, Chris Friesen wrote:
>> On 11/28/2012 02:27 PM, Mathias Bur=E9n wrote:
>>
>>> The drives look healthy, but am I reading that right? More than 10
>>> self tests per hour?
>>
>> Yeah....we cranked it up to try and increase how frequently we see t=
he
>> problem.
>>
>> From what I understand normally it runs once a day.
>>
>> Chris
>
> Did the vendor suggest to you that running a self test on an active
> drive would be OK? I would expect errors in this case - specifically
> time outs....

I'm not the main developer in that area, but from what I understand the=
=20
code has been like this for ages.  (It's entirely possible we've been=20
lucky up till now since we support limited hardware types.)

The fact that you'd expect time outs is interesting--is that from the=20
delay switching from doing the self-test to doing the actual request?

Is the expectation that the OS should not be sending any other commands=
=20
to the disk while doing the self-test?

I was recently looking at the SCSI spec trying to learn a bit about thi=
s=20
issue and the section on background self-test (spc-4, section 5.15.4.3)=
=20
seems to indicate that a READ or WRITE command should cause the=20
background self-test to be aborted and the command to be processed=20
within 2 seconds.  In our case it doesn't seem to be aborting (at least=
=20
it shows as "Completed" in smartctl)--is this expected?

Thanks,
Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
