From: David Brown <david.brown@hesbynett.no>
Subject: Re: Software RAID and TRIM
Date: Tue, 28 Jun 2011 18:40:45 +0200
Message-ID: <iud06d$ad5$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/11 17:31, Tom De Mulder wrote:
> Hi,
>
>
> I'm investigating SSD performance on Linux, in particular for RAID de=
vices.
>
> As I understand it=E2=80=94and please correct me if I'm wrong=E2=80=94=
currently software
> RAID does not pass through TRIM to the underlying devices. TRIM is
> essential for the continued high performance of SSDs, which otherwise
> degrade over time.
>
> I don't think there would be any harm in this command being passed
> through to underlying devices if they don't support it (they would ju=
st
> ignore it), and if they do it would make high-performance software RA=
ID
> of SSDs a possibility.
>
>
> Is this something that's in the works?
>
>

I don't think you are wrong about software raid not passing TRIM down t=
o=20
the device (IIRC, it /can/ be passed down through LVM raid setups, but=20
they are slower and less flexible than md raid).

However, AFAIUI, you are wrong about TRIM being essential for the=20
continued high performance of SSDs.  As long as your SSDs have some=20
over-provisioning (or you only partition something like 90% of the=20
drive), and it's got good garbage collection, then TRIM will have=20
minimal effect.

TRIM only makes a big difference in benchmarks which fill up most of a=20
disk, then erase the files, then start writing them again, and even the=
n=20
it is mainly with older flash controllers.

I think other SSD-optimisations, such as those in BTRFS, are much more=20
important.  These include bypassing or disabling code that is aimed at=20
optimising disk access and minimising head movement - such code is of=20
great benefit with hard disks, but helps little and adds latency on SSD=
=20
systems.

(I haven't done any benchmarks to justify this opinion, nor have I=20
direct links - it's based on my understanding of TRIM and how SSDs work=
,=20
and how SSD controllers have changed between early devices and current=20
ones.)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
