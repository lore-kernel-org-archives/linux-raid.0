From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Mon, 03 Dec 2012 15:22:04 -0500
Message-ID: <50BD09EC.5060705@redhat.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>	<50B67230.4080602@genband.com> <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com> <50B67417.2020606@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B67417.2020606@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2012 03:29 PM, Chris Friesen wrote:
> On 11/28/2012 02:27 PM, Mathias Bur=E9n wrote:
>
>> The drives look healthy, but am I reading that right? More than 10
>> self tests per hour?
>
> Yeah....we cranked it up to try and increase how frequently we see th=
e problem.
>
> From what I understand normally it runs once a day.
>
> Chris

Did the vendor suggest to you that running a self test on an active dri=
ve would=20
be OK? I would expect errors in this case - specifically time outs....

Regards,

Ric

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
