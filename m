From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Fri, 8 Feb 2013 00:37:34 -0700
Message-ID: <9B281B83-C3E2-40B5-96F5-A5F6895983C5@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com> <5114A791.3060802@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5114A791.3060802@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 8, 2013, at 12:21 AM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> I changed these two settings last night (noop and nr_request = 1) and
> today seemed to produce more complaints, and more errors logged about
> write failures, so I have restored nr_requests to 128 and the scheduler
> back to deadline.

Specifically what errors are being logged? And if this is on clients, what are you getting in dmesg on the storage server at the time of these errors? There might be a lot.


Chris Murphy