From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: RE: 3ware 7500-12, bad write speed
Date: Wed, 25 Sep 2002 23:04:49 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209252253590.26506-100000@twinlark.arctic.org>
References: <A1964EDB64C8094DA12D2271C04B812672C6FC@tabby>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A1964EDB64C8094DA12D2271C04B812672C6FC@tabby>
To: Adam Radford <aradford@3WARE.com>
Cc: 'Mikael Abrahamsson' <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 Sep 2002, Adam Radford wrote:

> What you are benchmarking is VM layer performance+filesystem
> performance+3ware device
> performance.
>
> Try some other settings or use a benchmark that issues raw asynchronous IO
> (not filesystem benchmark) (Iometer for Linux?)

unfortunately, raw io isn't a very realistic benchmark.  realistic
workloads have a filesystem :)

-dean

