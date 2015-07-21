From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Tue, 21 Jul 2015 00:55:28 -0400
Message-ID: <yq1wpxu154v.fsf@sermon.lab.mkp.net>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
	<yq1y4ibknz4.fsf@sermon.lab.mkp.net>
	<005601d0c36c$59d28ec0$0d77ac40$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005601d0c36c$59d28ec0$0d77ac40$@samsung.com> (Seunguk Shin's
	message of "Tue, 21 Jul 2015 13:18:52 +0900")
Sender: linux-raid-owner@vger.kernel.org
To: Seunguk Shin <seunguk.shin@samsung.com>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Seunguk" == Seunguk Shin <seunguk.shin@samsung.com> writes:

Seunguk,

Seunguk> The function bio_split says "The newly allocated bio will point
Seunguk> to @bio's bi_io_vec; it is the caller's responsibility to
Seunguk> ensure that @bio is not freed before the split." in its
Seunguk> comments.

I already put an explanatory comment above the cloning code. But I'll
elaborate in the function description as well.

Seunguk> I'm not sure whether some caller uses this limitation or not,
Seunguk> so I modifid the raid function.

We generally make sure our generic functions handle non-read/write
commands correctly so that callers do not have to keep track of internal
block layer implementation details/idiosyncrasies.

bio_split() exists mainly to provide linear/raid0/raid10 with a fast
path for reads and writes. But the function needs to be able to fall
back to a full clone in the discard case. The mutable bio_vec
requirement is purely an artifact of how things are implemented further
down the stack. MD should not have to deal with that.

Seunguk> The patch you shared has no problem, I think. I'll test it and
Seunguk> share the result.

That would be much appreciated!

Thanks,
Martin

-- 
Martin K. Petersen	Oracle Linux Engineering
