From: Burn Alting <burn@goldweb.com.au>
Subject: Hardware assisted parity computation - is it now worth it?
Date: Thu, 13 Jul 2006 18:18:59 +1000
Message-ID: <1152778739.26511.65.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last year, there were discussions on this list about the possible
use of a 'co-processor' (Intel's IOP333) to compute raid 5/6's
parity data.

We are about to see low cost, multi core cpu chips with very
high speed memory bandwidth. In light of this, is there any
effective benefit to such devices as the IOP333?

Or in other words, is a cheaper (power, heat, etc) cpu with
higher memory access speeds, more cost effective than a
bridge/bus device (ie hardware) solution (which typically
has much lower memory access speeds)?

Burn Alting
burn@goldweb.com.au

