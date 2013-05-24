From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 physical layout?
Date: Fri, 24 May 2013 15:13:41 -0400
Message-ID: <519FBBE5.7050802@turmel.org>
References: <20130524184930.GA9609@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130524184930.GA9609@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/24/2013 02:49 PM, Matt Garman wrote:
> 
> I'm looking into building a six-disk raid10.  The six disks are
> comprised of three from one manufacturer, and three from another.

> But based on what I've been reading, looks like mdadm's more
> sophisticated raid10 layout schemes give better performance.  For
> example, can I create a raid10,f2 set in such a way as to meet my
> "redundant copies on different manufacturer" criteria?

Just alternate the manufacturers when you list the devices in the
"--create" operation.  MD lays out raid10,f2 redundant data on adjacent
disks.  (Wraps around.)

Phil
