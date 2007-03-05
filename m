From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
Subject: How to copy a page to another page completely?
Date: Tue, 6 Mar 2007 01:49:29 +0800
Message-ID: <000001c75f4e$a0674a00$0100a8c0@sslabmayasky>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I tried "memcpy","__copy_to_user",and "__copy_to_user_inatomic",etc.
The destination is BIO's bio_vec->page (the page should be in userspace),
the source is a page of my modules; 
I get the addresses of the both pages from kmap() or kmap_atomic() then pass
to "memcpy" or "__copy_to_user" or "__copy_to_user_inatomic".
If the method can work, the buffer of userspace process will have the
context of the page of my module.
There is a problem that the context of buffer is incomplete when first run,
and the problem will disappear when run more time.
How to copy a page to another page completely?

THX

