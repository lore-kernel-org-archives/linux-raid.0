From: Arne Redlich <arne.redlich@googlemail.com>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported
 through LIO (iSCSI)
Date: Wed, 19 Sep 2012 08:44:32 +0200
Message-ID: <CA+XKKQpHkg1YCNzQ=tWhb6Ub1z9J4useJCqdykiFdY5Lxv0-Ag@mail.gmail.com>
References: <50588731.5050502@bananateam.nl>
	<1347997760.25356.16.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1347997760.25356.16.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Ferry <iscsitmp@bananateam.nl>, linux-raid@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-raid.ids

[Resending without HTML]

2012/9/18 Nicholas A. Bellinger <nab@linux-iscsi.org>:

> Also note that by default it's my understanding that IETD uses buffered
> FILEIO for performance, so in your particular type of setup you'd still
> see better performance with buffered FILEIO, but would still have the
> potential risk of silent data corruption with buffered FILEIO.

Nicholas,

IETs fileio defaults to writethrough caching (by issueing a sync after
writing and before returning a response to the client). Writeback
behaviour as employed by the OP needs to be switched on explicitly.

Also, the failure scenario for writeback caching you're referring to
is neither silent data corruption (as pointed out by Peter already)
nor silent data loss, as the WCE bit makes it pretty clear to the
client side that data is not guaranteed to be on persistent storage
unless explicitly flushed.

Arne
