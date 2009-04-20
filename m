From: Andrew Burgess <aab@cichlid.com>
Subject: Re: what superblock to use
Date: Mon, 20 Apr 2009 07:10:29 -0700
Message-ID: <1240236629.31728.30.camel@cichlid.com>
References: <49EC7B22.8070805@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EC7B22.8070805@lfarkas.org>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@lfarkas.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2009-04-20 at 15:39 +0200, Farkas Levente wrote:

> anyway is there any advantage of a raid6 over raid5+1spare disk? 

The raid6 owner sleeps soundly after a single disk failure.

