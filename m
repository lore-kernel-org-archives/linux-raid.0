From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 16:28:19 +0100
Message-ID: <20050123152819.GE24350@marowsky-bree.de>
References: <20050123151305.GB15317@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050123151305.GB15317@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On 2005-01-23T16:13:05, Luca Berra <bluca@comedia.it> wrote:

> the first one adds an auto=3Ddev parameter
> rationale: udev does not create /dev/md* device files, so we need a w=
ay
> to create them when assembling the md device.

Am I missing something but shouldn't this be fixed by having udev +
hotplug create the /dev entry correctly?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
