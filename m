From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Auto replace disk
Date: Wed, 8 Mar 2017 12:28:39 +0100
Message-ID: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all
I'm trying to configure mdadm to do automatic replace/rebuild when a
disk is phisically removed and replaced in a slot but without success

Is this possible? How?
The new disk must be formatted or mdadm will replicate partition table
on it's own?
