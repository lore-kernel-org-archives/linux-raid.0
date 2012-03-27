From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Invalidating the pages read from a disk which md marks as faulty later
Date: Tue, 27 Mar 2012 13:35:44 +0200
Message-ID: <CAGRgLy6GX+bfV0_rErHPGN--fHvpDGRD_4+i+aZ5u5sXRkrAsw@mail.gmail.com>
References: <CAHhTtBVqgv1Spgvkux55-K=y7CEYWs1qFQHXDSU_Kwu_NsuTaQ@mail.gmail.com>
	<20120119071955.03a3fe9d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120119071955.03a3fe9d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Krishnakumar R <krishnakumar.kernel@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

one issue that I hit, although not with md, is that Linux page cache
is capable of caching error'ed pages too. So even after the underlying
device recovers, the page cache keeps returning EIO for some time,
until it re-reads the page. To resolve this, it is either required to
close all open fds (opened with filp_open) or to issue
ioctl(BLKFLSBUF) to the file.

Perhaps that is what is meant here. Although I don't think md uses
Linux page cache to work with its components.

Alex.


On Wed, Jan 18, 2012 at 10:19 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 18 Jan 2012 20:11:38 +0530 Krishnakumar R
> <krishnakumar.kernel@gmail.com> wrote:
>
>> Hi,
>>
>> Does md invalidate the pages in the page cache for data read (earlie=
r) from
>> the disk, which md finds faulty, lets say due to an I/O error ?
>> The assumption here is that since md found a disk to be faulty, the =
data
>> which was earlier read and cached can be considered invalid. Thought=
s ?
>> I would assume that the pages would be backed by md device, hence is=
 it
>> possible to figure out which pages were given out with data from an
>> underlying disk inorder to invalidate them ?
>>
>>
>
> Sorry, but this doesn't make any sense.
>
> When you read from a disk, the disk drive itself does a CRC check to =
confirm
> the data is valid. =A0It if isn't you don't get to see the data. =A0I=
f it is, why
> would you want to invalidate it?
>
> If a device is "Faulty", that doesn't mean it has corrupted data. =A0=
It means
> it has inaccessible on unchangeable data.
>
> Though I might have =A0misunderstood you. =A0If you think I have, ple=
ase give a
> more detailed scenario of the situation that should be handled differ=
ently.
>
> In any case, once md has returned the data to the caller there is not=
hing it
> can do to "invalidate" it.
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
