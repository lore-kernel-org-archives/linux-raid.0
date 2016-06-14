From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm --detail --scan causes SIGABRT
Date: Tue, 14 Jun 2016 13:42:21 -0400
Message-ID: <wrfjvb1bfz0i.fsf@redhat.com>
References: <575A4018.8050500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <575A4018.8050500@redhat.com> (Nikhil Kshirsagar's message of
	"Fri, 10 Jun 2016 09:50:40 +0530")
Sender: linux-raid-owner@vger.kernel.org
To: Nikhil Kshirsagar <nkshirsa@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nikhil Kshirsagar <nkshirsa@redhat.com> writes:
> Please find attached a patch to fix BZ 1343809.
>
> Details:
> mdadm has a buffer overflow if mdinfo->sys_name needs to store a name
> larger than 20 characters.

Nikhil,

I have applied this one, adding the Signed-off-by: line as you
requested and slightly adjusted the patch description.

I would like to include some checking fixes too to avoid us overflowing
the new buffer size with even longer names.

Cheers,
Jes
