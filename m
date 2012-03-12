From: Erwan MAS <erwan@mas.nom.fr>
Subject: Re: Striping does not increase performance.
Date: Mon, 12 Mar 2012 13:57:20 +0100
Message-ID: <20120312125720.GL4558@voyageur.mas.nom.fr>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-raid@vger.kernel.org, fio@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 12, 2012 at 01:34:08PM +0100, Caspar Smit wrote:
> Hi all,
> 
> I don't know exactly which mailinglists to use for this one so I hope
> i used the right ones.
> 
> I did some performance testing on a new system and found out some
> things I couldn't explain or didn't expect.
> At the end are some questions I hope to get answered to explain the
> tings i'm seeing in the test.
> 
> First of all a description of my setup.
> 
> The server is a 36 bay 3,5" supermicro chassis filled with 36x 2TB
> SATA 7200 RPM disks. 
> [../..]

Please check alignement of each level of stockage . 
Because this disk present to controller a block size of 512 bytes , but internal 
use a 4k block size .

You must check that alignement is correct for :
  disk partionnemnt  
  md device          
  pv lvm             

-- 
     ____________________________________________________________
    / Erwan MAS                                                 /\
   | mailto:erwan@mas.nom.fr                                   |_/
___|________________________________________________________   |
\___________________________________________________________\__/
