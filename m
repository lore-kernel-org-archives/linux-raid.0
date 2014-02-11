From: Larry Fenske <LFenske@SGI.com>
Subject: sector mapping
Date: Tue, 11 Feb 2014 12:50:20 -0700
Message-ID: <52FA7EFC.8080001@SGI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is there any easy way for me to determine the mapping between sector
numbers in a RAID set and the locations of the underlying data and
syndromes?  For example, if I find that a particular sector of a
particular disk is marginal, how can I determine the affected sector
number(s) in the RAID set?  Is there a tool to compute this mapping, or
do I need to write it?

Thanks,
SGI signature

- Larry Fenske

