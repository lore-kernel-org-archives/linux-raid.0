From: Troy Cauble <troycauble@gmail.com>
Subject: raid-1, oops -- partition type 83
Date: Mon, 26 Jan 2009 09:37:37 -0500
Message-ID: <6d344ffd0901260637l1d705629l9e23db431a33a9af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid 1 with partition types 83 that I now realize should be 0xDA.
Is it safe to change this with fdisk live, or should I play it safe and do
   fail / remove / change-partition-type / add
on each disk?

Thanks,
-troy
