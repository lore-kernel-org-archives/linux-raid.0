From: Andrew Burgess <aab@cichlid.com>
Subject: Re:
Date: Thu, 02 Apr 2009 06:35:55 -0700
Message-ID: <1238679355.4604.19.camel@cichlid.com>
References: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-04-01 at 23:16 -0500, Lelsie Rhorer wrote:

> The issue is the entire array will occasionally pause completely for about
> 40 seconds when a file is created. 

I had symptoms like this once. It turned out to be a defective disk. The
disk would never return a read or write error but just intermittently
took a really long time to respond.

I found it by running atop. All the other drives would be running at low
utilization and this one drive would be at 100% when the symptoms
occurred (which in atop gets colored red so it jumps out at you)


