From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Wed, 18 Jul 2012 12:13:09 +0100
Message-ID: <CADNH=7FArALKO7VQ3whnqtHwR9ShBB=Atr_t_Ba=DM5MGAk+KA@mail.gmail.com>
References: <17025a94-1999-4619-b23d-7460946c2f85@zmail15.collab.prod.int.phx2.redhat.com>
	<a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18 July 2012 12:01, Jaromir Capik <jcapik@redhat.com> wrote:
> Hello.
>
> I'd like to ask you to implement the following ...
>
> The current RAID1 solution is not robust enough to protect the data
> against random data corruptions. Such corruptions usually happen
> when an unreadable sector is found by the drive's electronics
> and when the drive's trying to reallocate the sector to the spare area.
> There's no guarantee that the reallocated data will always match
> the original stored data since the drive sometimes can't read the data
> correctly even with several retries. That unfortunately completely masks
> the issue, because the sector can be read by the OS without problems
> even if it doesn't contain correct data. Would it be possible
> to implement chunk checksums to avoid such data corruptions?
> If a corrupted chunk is encountered, it would be taken from the second
> drive and immediately synced back. This would have a small performance
> and capacity impact (1 sector per chunk to minimize performance impact
> caused by unaligned granularity = 0.78% of the capacity with 64k chunks).
>
> Please, let me know if you find my request reasonable or not.
>
> Thanks in advance.
>
> Regards,
> Jaromir.
>
> --
> Jaromir Capik
> Red Hat Czech, s.r.o.
> Software Engineer / BaseOS
>
> Email: jcapik@redhat.com
> Web: www.cz.redhat.com
> Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
> IC: 27690016
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

That would be a disk format change...

Why not use btrfs or zfs?

Mathias
