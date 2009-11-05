From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Wed, 4 Nov 2009 22:17:00 -0800
Message-ID: <4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Short version:
Try running 'man mdadm.conf'  If that doesn't produce a manual page
please follow this link:

http://man-wiki.net/index.php/5:mdadm.conf

Long version:
Rescue is probably the name of the last system to update the
meta-data, either a rescue cd / system used for recovery or setup.

The normal mdadm manual page should elaborate the use of these options:

       -U, --update=homehost
       --auto-update-homehost
