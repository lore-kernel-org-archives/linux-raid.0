From: Richard Grundy <richguk@gmail.com>
Subject: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 14:06:17 +0000
Message-ID: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
would like to know the=C2=A0benefits of creating an LVM on top of this =
are
instead of just creating the filesystem on the md directly. I've never
had a problem growing the array and then resizing the filesystem
before and wondered if in this situation the only gain would be lvm
snapshot stuff? I'm planning to use ext4 for this array, if that makes
any difference.

Thanks in advanced,

Rich
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
