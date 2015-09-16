From: Justin Capella <justincapella@gmail.com>
Subject: Fwd: mdadm: not rebuilding IMSM array without OROM
Date: Wed, 16 Sep 2015 10:54:44 -0700
Message-ID: <CAMrEMU_du7HKa5x9dNpiBkp103-9NtF0fXD+Bv-Y6o41tEM85A@mail.gmail.com>
References: <CAMrEMU_LmmB-fmLkW1g6ptYnM-qbXNBJL58NR0Ok8Ecx_16KRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMrEMU_LmmB-fmLkW1g6ptYnM-qbXNBJL58NR0Ok8Ecx_16KRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In reference to the following commit:
http://git.neil.brown.name/?p=mdadm.git;a=commit;h=7eee461e91df702d8f588955b03e5bbb07e1f88d

I am unclear how to proceed given my unfortunate environment, where I
have replaced the motherboard. I am fearful of reconfiguring the raid
in OROM in case it causes data loss. Is anyone aware of a tool to
rebuild/configure the OROM settings from the autodetected ones?

Should I just modify my startup scripts in my initrd by hand to include --force?
