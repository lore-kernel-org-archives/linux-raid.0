From: "Kevin P. Fleming" <kpfleming@cox.net>
Subject: Re: [PATCH] convert md to use seq_file for /proc/mdstat
Date: Thu, 06 Mar 2003 08:08:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E676450.60805@cox.net>
References: <3E66E91E.1010307@cox.net> <3E6701E8.71C11255@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E6701E8.71C11255@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Hi Kevin,
> 
> I like the patch. I'm just curious...why'd you axe the CONFIG_PROC_FS
> ifdef's ?
> 
> --
> Paul
> 
> 
> 
>>-#ifdef CONFIG_PROC_FS
>>-       create_proc_read_entry("mdstat", 0, NULL, md_status_read_proc, NULL);
>>-#endif
> 
> 
> 
>>-#ifdef CONFIG_PROC_FS
>>        remove_proc_entry("mdstat", NULL);
>>-#endif

Two reasons, really:

- constant harping on LKML about how everyone hates #ifdefs <G>
- <linux/proc_fs.h> provides "return NULL" inline versions of these 
functions if CONFIG_PROC_FS is not defined, so presumably the compiler 
will just compile them away in that situation

