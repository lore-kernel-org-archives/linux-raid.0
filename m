From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: md: Fix a file name to md-fault.c in
 fault-injection.txt
Date: Mon, 1 Jan 2018 12:43:30 -0700
Message-ID: <20180101124330.1002d804@lwn.net>
References: <20171222164121.18054-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171222164121.18054-1-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: snitzer@redhat.com, shli@fb.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Dec 2017 01:41:21 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> drivers/md/faulty.c has been renamed to md-faulty.c after
> following commit merged int to the main line.
> 
>   935fe0983e09f4f7331ebf5ea4ae2124f6e9f9e8 .
> 
> But the file name in fault-injection.txt has not been changed.
> Now the actual file name and document are in sync.
> 
Applied to the docs tree, thanks.

jon
