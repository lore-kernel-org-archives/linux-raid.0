From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [PATCH] convert md to use seq_file for /proc/mdstat
Date: Thu, 06 Mar 2003 03:08:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E6701E8.71C11255@SteelEye.com>
References: <3E66E91E.1010307@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Kevin P. Fleming" <kpfleming@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kevin,

I like the patch. I'm just curious...why'd you axe the CONFIG_PROC_FS
ifdef's ?

--
Paul


> -#ifdef CONFIG_PROC_FS
> -       create_proc_read_entry("mdstat", 0, NULL, md_status_read_proc, NULL);
> -#endif


> -#ifdef CONFIG_PROC_FS
>         remove_proc_entry("mdstat", NULL);
> -#endif
