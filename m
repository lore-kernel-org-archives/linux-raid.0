From: Phil Turmel <philip@turmel.org>
Subject: Re: What are mdadm maintainers to do?
Date: Mon, 16 Feb 2015 14:44:11 -0500
Message-ID: <54E2488B.5060903@turmel.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org> <loom.20150216T183419-387@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150216T183419-387@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2015 12:48 PM, Chris wrote:
> 
> Thank you for the additional information, it calls for action.
> 
> 
> OK, calling for a solution to stop desktop drives from causing data loss and
> affecting the mdadm reputation:
> 
> 
> I gather that mdadm could ship with one additional udev rule that calls a
> script to check/set scterc, or falls back to increasing the system timout.
> 
> Phil, you mentioned having posted such a script, could you prepare it for
> addition to the mdadm package?

No, I've posted snippets for users to customize in their own rc.local or
distro equivalent.  I vaguely recall posting a generic script for some
common cases, but I've personally converted to raid-rated drives
everywhere in the past couple years.

Somebody else will have to tackle this.

> Would maintainers be ok with adding such a udev rule and script to the package?

Not my call, but keep in mind that this will add a dependency on
smartmontools or whatever means is used to access/write to scterc.

Phil
