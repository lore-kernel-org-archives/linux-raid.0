From: wiebittewas <wiebittewas@googlemail.com>
Subject: rw-mount necessary while assemble?
Date: Mon, 26 Jul 2010 18:58:04 +0000
Message-ID: <4C4DDABC.7090202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

is it really necessary to have /dev writeable when running mdadm
--assemble --scan?

seems, that mdadm creates temporary nodes for the devices, even if
there're already usable nodes...

any option that disables this need?

(want to call fsck -a during boot, but this needs ro-mount of root,
where /dev is on, but this make only sense, if the md-devices are up
and running)

w.
