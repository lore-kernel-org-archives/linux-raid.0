From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/1] super-intel.c: use %zu specifier for printf of size_t
Date: Sun, 31 Jan 2010 12:56:30 -0700
Message-ID: <e9c3a7c21001311156m10706039yce93a7f5a548db2c@mail.gmail.com>
References: <20100130095928.GD15471@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100130095928.GD15471@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 30, 2010 at 2:59 AM, Luca Berra <bluca@comedia.it> wrote:
>
> Signed-off-by: Luca Berra <bluca@vodka.it>

Acked-by: Dan Williams <dan.j.williams@intel.com>

It's obvious but changelog could say:

     Fix compile warning when size_t is not a long.
