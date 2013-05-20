From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Resync raid array problem
Date: Mon, 20 May 2013 11:46:17 +0800
Message-ID: <51999C89.6090001@fnarfbargle.com>
References: <loom.20130520T035627-78@post.gmane.org> <7rfo6axs9j.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7rfo6axs9j.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/05/13 10:53, Keith Keller wrote:
> On 2013-05-20, Tarak <tarakramgopal@gmail.com> wrote:
>> We sucessfully created a Raid array of 8 harddisks.
>> On power failure situation,
>
> You should probably have some sort of redundant power for such an
> array--either a UPS or backup power provided by a building generator.
>

Can't agree with this strongly enough. Grab the best UPS you can afford 
(and often that means getting a 10 year old one second hand and 
replacing the batteries). Best investment I _ever_ made was a 2000 
vintage APC SmartUPS 2200 and it cost all of about $200 second hand, 
plus another $100 for new batteries.

Also, look at adding a bitmap to your array. Then it will only resync 
what it suspects might be dirty.


