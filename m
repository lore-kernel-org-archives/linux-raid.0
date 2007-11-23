From: "Chris Green" <cgreen@valvesoftware.com>
Subject: Re: Proposal: non-striping RAID4
Date: Fri, 23 Nov 2007 07:58:35 -0800
Message-ID: <BC2A76AABABF8741A8ADEE62DB1350F80384B9B7@exchange2.valvesoftware.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Ignoring the issues of using mismatched drive sizes, is it possible to 
achieve the data resilience of this non-striped raid4 using the current
linux-raid?

 I'm not so interested in being able to use mismatched drives, etc,
but I am interested in being able to create a raid setup with the
enhanced data loss protection that this gives you. For a read-mostly
system that doesn't need the extra read speed that raid5 gets you, its
pretty compelling. With a 5 drive raid5 system, if I lose 2 drives, I
lose all my data, while with this setup, I only lose 1/4 of it

