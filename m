From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Use more secure HTTPS URLs
Date: Wed, 13 May 2020 09:44:57 -0400
Message-ID: <f2d4fa4e-697f-033a-1144-d4ff30e48ec3@gmail.com>
References: <20200513132707.16744-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200513132707.16744-1-pmenzel@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/13/20 9:27 AM, Paul Menzel wrote:
> All URLs in the source are available over HTTPS, so convert all URLs to
> HTTPS with the command below.
> 
>     git grep -l 'http://' | xargs sed -i 's,http://,https://,g'
> 
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

Some of this looks valid, but we're not going back to update existing
ANNOUNCE files.

Jes

> ---
>  ANNOUNCE-3.0                     | 4 ++--
>  ANNOUNCE-3.0.1                   | 4 ++--
>  ANNOUNCE-3.0.2                   | 4 ++--
>  ANNOUNCE-3.0.3                   | 4 ++--
>  ANNOUNCE-3.1                     | 4 ++--
>  ANNOUNCE-3.1.1                   | 4 ++--
>  ANNOUNCE-3.1.2                   | 4 ++--
>  ANNOUNCE-3.1.3                   | 4 ++--
>  ANNOUNCE-3.1.4                   | 4 ++--
>  ANNOUNCE-3.1.5                   | 4 ++--
>  ANNOUNCE-3.2                     | 4 ++--
>  ANNOUNCE-3.2.1                   | 4 ++--
>  ANNOUNCE-3.2.2                   | 4 ++--
>  ANNOUNCE-3.2.3                   | 4 ++--
>  ANNOUNCE-3.2.4                   | 4 ++--
>  ANNOUNCE-3.2.5                   | 4 ++--
>  ANNOUNCE-3.2.6                   | 4 ++--
>  ANNOUNCE-3.3                     | 4 ++--
>  ANNOUNCE-3.3.1                   | 4 ++--
>  ANNOUNCE-3.3.2                   | 4 ++--
>  ANNOUNCE-3.3.3                   | 4 ++--
>  ANNOUNCE-3.3.4                   | 4 ++--
>  ANNOUNCE-3.4                     | 4 ++--
>  ANNOUNCE-4.0                     | 4 ++--
>  ANNOUNCE-4.1                     | 4 ++--
>  external-reshape-design.txt      | 2 +-
>  mdadm.8.in                       | 6 +++---
>  mdadm.spec                       | 4 ++--
>  raid6check.8                     | 2 +-
>  restripe.c                       | 2 +-
>  udev-md-raid-safe-timeouts.rules | 2 +-
>  31 files changed, 59 insertions(+), 59 deletions(-)
