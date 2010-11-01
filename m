From: Matt Garman <matthew.garman@gmail.com>
Subject: status of sas1068 ata-passthrough bug?
Date: Mon, 1 Nov 2010 17:08:38 -0500
Message-ID: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've seen a few mentions on this list of kernel bug 14831 / 13594,
where drives on an LSI SAS1068 controller are dropped when smartd is
run:

https://bugzilla.kernel.org/show_bug.cgi?id=14831
https://bugzilla.kernel.org/show_bug.cgi?id=13594

I was just wondering if this bug is "officially" fixed, and if so, in
what kernel version?  The Bugzilla entries above don't show it as
fixed, but I saw on this list someone mentioned that it's fixed in
2.6.36 (I think---I can't find that post now).

Thanks,
Matt
