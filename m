From: Ferry <iscsitmp@bananateam.nl>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported
 through LIO (iSCSI)
Date: Wed, 19 Sep 2012 16:27:00 +0200
Message-ID: <5059D634.1020509@bananateam.nl>
References: <50588731.5050502@bananateam.nl> <1347997760.25356.16.camel@haakon2.linux-iscsi.org> <CA+XKKQpHkg1YCNzQ=tWhb6Ub1z9J4useJCqdykiFdY5Lxv0-Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+XKKQpHkg1YCNzQ=tWhb6Ub1z9J4useJCqdykiFdY5Lxv0-Ag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-raid.ids

On 19-09-12 08:44, Arne Redlich wrote:
> [Resending without HTML]
>
> 2012/9/18 Nicholas A. Bellinger <nab@linux-iscsi.org>:
>
>> Also note that by default it's my understanding that IETD uses buffered
>> FILEIO for performance, so in your particular type of setup you'd still
>> see better performance with buffered FILEIO, but would still have the
>> potential risk of silent data corruption with buffered FILEIO.
> Nicholas,
>
> IETs fileio defaults to writethrough caching (by issueing a sync after
> writing and before returning a response to the client). Writeback
> behaviour as employed by the OP needs to be switched on explicitly.
>
> Also, the failure scenario for writeback caching you're referring to
> is neither silent data corruption (as pointed out by Peter already)
> nor silent data loss, as the WCE bit makes it pretty clear to the
> client side that data is not guaranteed to be on persistent storage
> unless explicitly flushed.
>
> Arne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

What's the definition of explicitly flushed here? For example, vmware
does nothing but sync I/O. Just start a NFS server on non-cached storage
and run a vm of it, then force the export to async and it'll be lots and
lots faster. I know from test labs setting IET to fileio with writeback
is notably (much) faster than fileio with write through (on non-cached
storage oc). Is this the same as explicitly flushing? Because then it
wouldn't make sense to me that that it's faster with writeback caching
since all I/O is sync from vmware (or more accurately ESX(i)).

Also wouldn't explain why the buffers fill as seen by the free tool for
example :).
