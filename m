From: "Kevin P. Fleming" <kpfleming@starnetworks.us>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Sun, 23 Jan 2005 07:42:43 -0700
Message-ID: <41F3B7E3.4030603@starnetworks.us>
References: <38038.212.158.231.74.1099526180.squirrel@mail.fsck.co.uk>    <200412090021.iB90L4MK014200@terminus.zytor.com> <33023.212.158.231.74.1106488921.squirrel@mail.fsck.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33023.212.158.231.74.1106488921.squirrel@mail.fsck.co.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A. James Lewis wrote:

> At the moment, I am experimenting with RAID on top of USB Mass Storage
> devices... it's interesting because the USB system takes a significant
> time to identify and make each drive available, and I have to determine if
> all the drives have become available before starting any arrays....

You'd be best off to leverage the hotplug infrastructure (userspace 
scripts) and just not try to start the array until you know all the 
members are available.
