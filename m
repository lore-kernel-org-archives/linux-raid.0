From: Michal Soltys <nozo@ziu.info>
Subject: mdadm and superblock format > 1
Date: Tue, 07 Aug 2007 12:21:16 +0200
Message-ID: <46B8479C.5010600@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've noticed, that whenever I use 1.1 or 1.2 superblock format, mdadm 
will always report version 1, when i.e. mdadm -E --scan is issued.

Also, in these two cases, mdadm -A --scan won't work, unless proper 
ARRAY line is present in mdadm.conf (and if metadata is part of the 
description, it must be either 1.1 or 1.2).


