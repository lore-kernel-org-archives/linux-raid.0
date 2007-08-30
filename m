From: Neil Brown <neilb@suse.de>
Subject: RE: Raid5 Reshape gone wrong, please help
Date: Thu, 30 Aug 2007 15:47:42 +1000
Message-ID: <18134.23038.904387.906122@notabene.brown>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	<18118.46141.966406.577626@notabene.brown>
	<c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
	<18120.9950.578786.624453@notabene.brown>
	<c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>
	<c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>
	<c92bcddf0708201909w2534c25du6282fd661ed838f5@mail.gmail.com>
	<c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com>
	<18130.44566.69917.341927@notabene.brown>
	<0C7297FA1D2D244A9C7F6959C0BF1E52025B0F20@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Williams, Dan J on Monday August 27
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Greg Nicholson <d0gz.net@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 27, dan.j.williams@intel.com wrote:
> > -		s.locked += handle_write_operations5(sh, 0, 1);
> > +		s.locked += handle_write_operations5(sh, 1, 1);
> How about for clarity:
> 	s.locked += handle_write_operations5(sh, RECONSTRUCT_WRITE, 1);
> 

Nope.  That second argument is a boolean, not an enum.
If it was changed to 'writemode' (or similar) and the code in
handle_write_operations5 were changed to

  switch(writemode) {
  case RECONSTRUCT_WRITE:
         ....
  case READ_MODIFY_WRITE:
         ....
  }

Then it would make sense to use RECONSTRUCT_WRITE in the call - and
the code would probably be more readable on the whole.
But as it is, either 'true' or '1' should go there.

NeilBrown

  
