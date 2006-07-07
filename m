From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Setting up mdadm.conf for UUID?
Date: Fri, 7 Jul 2006 07:39:12 -0500
Message-ID: <6d5bedd80607070539x53df9eeet8d4ba31acb283ee5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My RAID-5 array is composed of six USB drives. Unfortunately, my
Ubuntu Dapper system doesn't always assign the same devices to the
drives after a reboot. However, mdadm doesn't seem to like having an
mdadm.conf that doesn't have a Devices line with specified device
names.

Anyway to setup an mdadm.conf so that it will just assemble the drives
using the UUID of the array? Or is the trick to not have an mdadm.conf
and add something to a runlevel script?

TIA,
Ewan
