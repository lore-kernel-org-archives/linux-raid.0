From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Questions Degraded Array with LVM
Date: Mon, 30 Jun 2003 16:34:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030630163420.C6102@newbox.localdomain>
References: <20030627234920.95101.qmail@web20418.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030627234920.95101.qmail@web20418.mail.yahoo.com>; from mgeusenet@yahoo.com on Fri, Jun 27, 2003 at 04:49:20PM -0700
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt E on Fri 27/06 16:49 -0700:
> 4) Copy the data from the old LVM array to the new
> RAID-5/LVM array.
>
> Does anyone know if this is the right way to do this? 

probably using pvmove and resizefs is a better approach.
