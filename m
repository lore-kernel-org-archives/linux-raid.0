From: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under      Linux
Date: Mon, 7 Jun 2004 09:50:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ca16n8$k3p$1@sea.gmane.org>
References: <40498.194.60.85.4.1086343953.squirrel@194.60.85.4> <40C346A6.1000001@xss.co.at>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andreas Haumer <andreas@xss.co.at> wrote:
> What are the advantages of a partitionable md device
> compared to a SWRAID+LVM configuration?

You don't need LVM and thus you have one less layer
with potential failures and errors.


regards,
   Mario
-- 
<delta> talk softly and carry a keen sword

