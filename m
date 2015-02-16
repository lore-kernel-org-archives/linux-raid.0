From: Phil Turmel <philip@turmel.org>
Subject: Re: re-add POLICY
Date: Mon, 16 Feb 2015 08:17:30 -0500
Message-ID: <54E1EDEA.1030503@turmel.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150216T124230-883@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Chris,

On 02/16/2015 07:23 AM, Chris wrote:
> .... with raid members that got pulled and are save to
> re-sync. (e.g. after the occasional bad block error that gets remapped by
> the hardrives firmware)

This should not be part of your concern here, as MD will handle
occassional UREs by reconstructing them and rewriting them on the fly,
-- without failing the device.  If devices are failing after read
errors, you have a different problem.  (Hint:  look at recent threads
for "timeout mismatch".)

Phil

