From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Wed, 4 Nov 2009 23:31:20 -0800
Message-ID: <4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	 <4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
	 <babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To better cooperate with various initrd and recovery cd you should
probably use a numeric only array name, as well as the /dev/mdX
numbering scheme.

You should read the manuals more carefully, it is possible to update
the name and/or homehost name for arrays DURING ASSEMBLY using the
update option, hence my reference to the manual.
